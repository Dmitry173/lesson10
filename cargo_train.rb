# frozen_string_literal: true

class CargoTrain < Train

  FORMAT_NUMBER = /^[a-zа-я\d]{3}[-]?[a-zа-я\d]{2}$/i.freeze

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  def initialize(number)
    super
    @type = :cargo
  end

  def add_carriage(carriage)
    carriage.is_a?(CargoCarriage)
  end
end
