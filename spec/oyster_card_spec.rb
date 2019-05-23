#!/bin/env ruby
# encoding: utf-8

require './lib/oyster_card'

describe OysterCard do

  let(:entry_station) { double(:station, :name => "Barbican") }
  let(:exit_station) { double(:station, :name => "Camden Town") }
  let(:oyster_card) { OysterCard.new(journey_class) }
  let(:journey) { double(:journey, :complete? => true, :entry_station => entry_station, :exit_station => exit_station).as_null_object }
  let(:journey_class) { double(:journey_class, :new => journey )}


  it 'can get the current balance on the oyster card' do
    oyster_card.top_up(10)
    expect(oyster_card.balance).to eq(10)
  end

  it 'balance can be topped up' do
    expect(oyster_card.top_up(10)).to eq(10)
  end

  it 'sets a limit of £90 on the card' do
    oyster_card.top_up(90)
    expect{oyster_card.top_up(1)}.to raise_error "Top up limit exceeded"
  end

  # it 'can deduct a fare from the card' do
  #   oyster_card.top_up(OysterCard::DEFAULT_LIMIT)
  #   oyster_card.touch_out(90, exit_station)
  #
  #   expect(oyster_card.balance).to eq(0)
  # end

  it 'needs a minimum of £1' do
    expect{oyster_card.touch_in(entry_station)}.to raise_error "You need a minimum of £1"
  end

  # it 'will deduct a fare when you complete a journey' do
  #   oyster_card.top_up(10)
  #   expect{ oyster_card.touch_out(2) }.to change { oyster_card.balance }.by(-2)
  # end

  it 'has an empty list of journeys by default' do
    expect(oyster_card.journeys).to eq([])
  end

  it 'starts a journey when you touch in' do
    oyster_card.top_up(10)
    expect(journey).to receive(:start).with(entry_station)
    oyster_card.touch_in(entry_station)
  end

  it 'ends a journey when you touch out' do
    oyster_card.top_up(10)
    expect(journey).to receive(:stop).with(exit_station)
    oyster_card.touch_out(exit_station)
  end

  it 'stores a list of journeys' do
    oyster_card.top_up(10)
    oyster_card.touch_in(entry_station)
    oyster_card.touch_out(exit_station)
    oyster_card.deduct_fare
    expect(oyster_card.journey_list).to eq("Barbican - Camden Town")
  end
  
  context '#fare' do
    it 'deducts the minimum fare when journey is complete' do
      oyster_card.top_up(10)
      oyster_card.deduct_fare
      expect{ oyster_card.deduct_fare }.to change { oyster_card.balance }.by(-2)
    end

    it 'deducts the penalty fare when journey is incomplete' do
      allow(journey).to receive(:complete?).and_return(false)
      oyster_card.top_up(10)
      oyster_card.deduct_fare
      expect{ oyster_card.deduct_fare }.to change { oyster_card.balance }.by(-6)
    end
  end

end
