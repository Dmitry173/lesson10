# frozen_string_literal: true

require_relative('./instance_counter')
require_relative('./validation')
require_relative('./accessors')

class Station
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :name, :trains
  strong_attr_accessor :name, String

  validate :name, :presence

  @@all = []

  def initialize(name)
    @name = name
    @trains = []
    @@all << self
    validate!
  end

  def self.all
    @@all
  end

  def get_train(train)
    @trains << train
  end

  def each_train(&block)
    @trains.each(&block)
  end

  def send_train(train)
    trains.delete(train)
  end

  def show_trains
    @trains.each.with_index(1) do |train, index|
      puts "#{index}. Поезд № #{train.number}, типа - #{train.type}, количество вагонов - #{train.carriages.count}"
    end
  end

  def show_type(type)
    trains.each { |train| train.type == type }
  end
end
