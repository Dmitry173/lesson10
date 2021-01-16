# frozen_string_literal: true

require_relative('./info')
require_relative('./instance_counter')
require_relative('./validation')
require_relative('./accessors')

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  include Validation

  attr_accessor :speed, :route, :type, :number, :carriages, :station
  strong_attr_accessor :number, String

  NUMBER_FORMAT = /^[a-zа-яA-ZА-Я\d]{3}-?[a-zа-яA-ZА-Я\d]{2}$/i.freeze

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  @@trains = {}

  def initialize(number, speed = 0)
    @number = number
    @type = type
    @speed = speed
    @carriages = []
    validate!
    @@trains[number] = self
    register_instance
  end

  def each_carriage(&block)
    @carriages.each(&block)
  end

  def add_carriage(carriage)
    @carriages << carriage if speed.zero? && attachable_carriage?(carriage)
  end

  def remove_carriage(carriage)
    return if speed != 0

    @carriages.delete(carriage) if @carriages.include?(carriage)
  end

  def show_carriage
    @carriages.each { |carriage| puts carriage }
  end

  def speed_up(speed)
    @speed += speed
  end

  def stop
    @speed = 0
  end

  def current_speed
    @current_speed = @speed
  end

  def add_route(route)
    @route = route
    @station = route.first_station
    @station.get_train(self)
  end

  def move_next
    return unless next_station

    @station.send_train(self)
    @station = next_station
    @station.get_train(self)
  end

  def move_previous
    return unless previous_station

    @station.send_train(self)
    @station = previous_station
    @station.get_train(self)
  end

  def self.find(number)
    @@trains[number]
  end

  def next_station
    route.stations[route.stations.index(@station) + 1] if @station != route.stations.last
  end

  def previous_station
    route.stations[route.stations.index(@station) - 1] if @station != route.stations.first
  end
end
