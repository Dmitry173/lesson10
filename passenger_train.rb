# frozen_string_literal: true

class PassengerTrain < Train

  FORMAT_NUMBER = /^[a-zа-я\d]{3}[-]?[a-zа-я\d]{2}$/i.freeze

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  def initialize(number)
    super
    @type = :passenger
  end

  def add_carriage(carriage)
    carriage.is_a?(PassCarriage)
  end
end
