# frozen_string_literal: true

require_relative('./instance_counter')
require_relative('./validation')
require_relative('./accessors')
require_relative('./station')


class Route
  include InstanceCounter
  include Validate
  extend Accessors

  attr_accessor :stations

  validate :first_station, :type, Station
  validate :last_station, :type, Station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    return if first_station == last_station

    @stations = [first_station, last_station]
    validate!
    register_instance
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    return if station == stations.first || station == stations.last

    @stations.delete(station) if stations.include?(station)
  end

  def show_station
    @stations.each { |station| puts station }
  end
end
