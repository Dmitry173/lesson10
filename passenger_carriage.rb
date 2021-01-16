# frozen_string_literal: true

class PassengerCarriage < Carriage
  def initialize(number, place)
    super(number, :passenger, place)
  end

  def occupy_place
    raise 'Недостаточно свободных мест' if free_place <= 0

    super(1)
  rescue Exception => e
    puts e.message
  end
end
