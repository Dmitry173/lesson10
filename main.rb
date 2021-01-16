# frozen_string_literal: true

require_relative('./station')
require_relative('./route')
require_relative('./train')
require_relative('./carriage')
require_relative('./cargo_carriage')
require_relative('./passenger_carriage')
require_relative('./cargo_train')
require_relative('./passenger_train')

class Railway
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @carriages = []
  end

  def menu
    loop do
      puts ' '
      puts "Введите '1' для входа в меню со станциями"
      puts "Введите '2' для входа в меню с поездами"
      puts "Введите '3' для входа в меню с маршрутами"
      puts "Введите '0' чтобы выйти"
      answer = gets.to_i
      case answer
      when 1 then station_manager
      when 2 then train_manager
      when 3 then route_manager
      when 0 then break
      else puts 'Введите другое значение'
      end
    end
  end

  def station_manager
    loop do
      puts ' '
      puts "Введите '1' чтобы создать станцию "
      puts "Введите '2' чтобы посмотреть список станций и поездов "
      puts "Введите '0' чтобы вернуться в общее меню"
      answer = gets.to_i
      case answer
      when 1 then new_station
      when 2 then show_trains_on_station
      when 0 then break
      else puts 'Введите другое значение'
      end
    end
  end

  def train_manager
    loop do
      puts ' '
      puts "Введите '1' чтобы создать поезд "
      puts "Введите '2' чтобы прицепить к поезду вагон "
      puts "Введите '3' чтобы отцепить от поезда вагон "
      puts "Введите '4' чтобы переместить поезд "
      puts "Введите '5' чтобы занять место в вагоне "
      puts "Введите '6' чтобы посмотреть список вагонов у поезда "
      puts "Введите '0' чтобы вернуться в меню"
      answer = gets.to_i
      case answer
      when 1 then new_train
      when 2 then add_carriage
      when 3 then remove_carriage
      when 4 then train_move
      when 5 then take_carriage_place
      when 6 then show_train_carriages
      when 0 then break
      else puts 'Введите другое значение'
      end
    end
  end

  def route_manager
    loop do
      puts ' '
      puts "Введите '1' чтобы создать маршрут"
      puts "Введите '2' чтобы добавить станцию в маршрут"
      puts "Введите '3' чтобы удалить станцию из маршрута"
      puts "Введите '4' чтобы посмотреть маршрут"
      puts "Введите '5' чтобы назначить маршрут поезду"
      puts "Введите '0' вернуться в меню"
      answer = gets.to_i
      case answer
      when 1 then create_route
      when 2 then add_station_to_route
      when 3 then remove_station_from_route
      when 4 then show_routes
      when 5 then add_route
      when 0 then break
      else puts 'Введите другое значение'
      end
    end
  end

  def new_station
    puts 'Введите название станции'
    name = gets.chomp
    new_station = Station.new(name)
    @stations.push(new_station)
    puts "Построена станция #{name}"
  rescue Exception => e
    puts e.message
    retry
  end

  def new_train
    puts 'Введите тип поезда (1 - грузовой / 2 - пассажирский)'
    type = gets.chomp
    puts 'Введите номер поезда в пятизначном формате'
    number = gets.chomp
    case type
    when '1'
      @trains.push(CargoTrain.new(number))
      puts "Создан поезд под номером #{number} типа cargo"
    when '2'
      @trains.push(PassengerTrain.new(number))
      puts "Создан поезд под номером #{number} типа passenger"
    else
      puts 'Данного типа поезда не существует'
    end
  rescue Exception => e
    puts e.message
    retry
  end

  def add_carriage
    train = select_train
    case train.type
    when :cargo
      puts 'Введите номер вагона'
      number = gets.chomp.to_i
      puts 'Введите объём грузового вагона'
      volume = gets.chomp.to_i
      carriage = CargoCarriage.new(number, volume)
      train.carriages.push(carriage)
      @carriages << carriage
      puts "К поезду  № #{train.number} добавлен вагон, всего вагонов у поезда - #{train.carriages.size} "
    when :passenger
      puts 'Введите номер вагона'
      number = gets.chomp.to_i
      puts 'Введите количество мест в вагоне'
      seats = gets.chomp.to_i
      carriage = PassengerCarriage.new(number, seats)
      train.carriages.push(carriage)
      @carriages << carriage
      puts "К поезду  № #{train.number} добавлен вагон, всего вагонов у поезда - #{train.carriages.size} "
    else
      puts 'Что-то сработало не так'
    end
  end

  def create_route
    puts 'Выберите станцию отправления'
    first_station = select_station
    puts 'Выберите станцию назначения'
    last_station = select_station
    @routes.push(Route.new(first_station, last_station))
    puts "Создан маршрут от станции #{first_station.name} до станции #{last_station.name}"
  rescue Exception => e
    puts e.message
  end

  def add_station_to_route
    route = select_route
    station = select_station
    if route.stations.include?(station)
      puts 'Данная станция есть в маршруте'
    else
      route.add_station(station)
      puts "Станция #{station.name} добавлена к маршруту"
    end
  end

  def remove_station_from_route
    route = select_route
    station = select_station
    if station == route.first_station || station == route.last_station
      puts 'Нельзя удалить начальную и конечную станции'
    elsif route.stations.include?(station)
      route.stations.delete(station)
      puts "Станция #{station.name} удалена из маршрута"
    else
      puts 'Данной станции нет в маршруте'
    end
  end

  def show_trains
    @trains.each.with_index(1) do |train, x|
      puts "#{x}. Поезд № #{train.number}, типа - #{train.type}, количество вагонов - #{train.carriages.count}"
    end
  end

  def show_routes
    @routes.each.with_index(1) do |route, x|
      print "#{x}. Из станции #{route.stations[0].name} до станции #{route.stations[-1].name} \n"
    end
  end

  def show_stations
    @stations.each.with_index(1) { |station, x| puts "#{x}. #{station.name}" }
  end

  def show_train_route
    train = select_train
    puts "Маршрут = #{train.route.stations}"
  end

  def show_train_carriages
    train = select_train
    train.carriages.each.with_index(1) do |carriage, x|
      puts "#{x}. Вагон № #{carriage.number}. Тип вагона: #{carriage.type}. Свободно: #{carriage.free_place}. Занято: #{carriage.occupied_place}"
    end
  end

  def select_train
    puts 'Выберите поезд:'
    show_trains
    @trains[gets.to_i - 1]
  end

  def select_route
    puts "Выберите маршрут: \n"
    show_routes
    @routes[gets.to_i - 1]
  end

  def select_station
    puts 'Выберите станцию: '
    show_stations
    @stations[gets.to_i - 1]
  end

  def select_carriage(train)
    train.carriages.each.with_index(1) do |carriage, x|
      puts "#{x}. Вагон № #{carriage.number}. Тип вагона: #{carriage.type}. Свободно: #{carriage.free_place}. Занято: #{carriage.occupied_place}"
    end
    @carriages[gets.to_i - 1]
  end

  def remove_carriage
    train = select_train
    carriage = select_carriage(train)
    train.remove_carriage(carriage)
    puts "У поезда  №#{train.number} убран вагон № #{carriage.number}, всего вагонов у поезда - #{train.carriages.size} "
  end

  def add_route
    route = select_route
    train = select_train
    train.add_route(route)
    puts "К поезду №#{train.number} добавлен маршрут от станции #{route.first_station.name} до станции #{route.last_station.name}"
  end

  def train_move
    train = select_train
    loop do
      puts "Введите '1' чтобы отправить поезд на следующую станцию"
      puts "Введите '2' чтобы отправить поезд на предыдущую станцию"
      puts "Введите '3' чтобы вернуться назад"
      case gets.to_i
      when 1
        train.move_next
        puts "Станция - #{train.station.name}"
        puts "Следующая станция - #{train.next_station.name}" unless train.next_station.nil?
      when 2
        train.move_previous
        puts "Станция - #{train.station.name}"
        puts "Следующая станция - #{train.previous_station.name}" unless train.previous_station.nil?
      when 3 then break
      else puts 'Введите другое значение'
      end
    end
  end

  def take_carriage_place
    train = select_train
    carriage = select_carriage(train)
    if carriage.is_a?(CargoCarriage)
      puts 'Введите величину объёма, которую хотите занять'
      place = gets.to_i
      carriage.occupy_place(place)
      puts "Мест занято: #{carriage.occupied_place}. Мест свободно: #{carriage.free_place}"
    else
      carriage.occupy_place
      puts "Занято: #{carriage.occupied_place}. Свободно: #{carriage.free_place}"
    end
  end

  def show_trains_on_station
    @stations.each do |station|
      if !station.trains.empty?
        trains = []
        puts "Станция: #{station.name}\nПоезда на станции:"
        station.trains.each do |train, x|
          trains << train
          puts "#{x}. Поезд № #{train.number}, типа - #{train.type}, количество вагонов - #{train.carriages.count}"
        end
      else
        puts "Станция: #{station.name}.\nПоездов нет."
      end
    end
  end
end

railway = Railway.new
railway.menu
