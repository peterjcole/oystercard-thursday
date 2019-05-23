#!/bin/env ruby
# encoding: utf-8

class OysterCard

  attr_reader :entry_station, :exit_station, :journeys, :balance
  DEFAULT_LIMIT = 90
  MINIMUM = 1
  FARE = 2
  PENALTY_FARE = 6

  def initialize( journey_class=Journey )
    @balance = 0
    @entry_station =  nil
    @journeys = []
    @journey_class = journey_class
    @current_journey = journey_class.new
  end

  def top_up(money)
    @balance += money
    raise "Top up limit exceeded" if @balance > DEFAULT_LIMIT
    @balance
  end

  def touch_in(station)
    raise "You need a minimum of £1" if @balance < MINIMUM
    @entry_station = station
    @current_journey.start(station)
  end

  def touch_out(station)
    @exit_station = station
    store_trips
    @entry_station = nil
    @current_journey.stop(station)
  end

  def deduct_fare
    @current_journey.complete? ? @balance -= FARE : @balance -= PENALTY_FARE
  end

  private

  def store_trips
    @journeys.push(@current_journey)
  end









end
