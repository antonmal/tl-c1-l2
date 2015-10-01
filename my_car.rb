class Vehicle

  attr_accessor :brand, :model, :color, :speed
  attr_reader :year
  @@vehicle_number = 0

  def initialize(brand, model, year, color)
    self.brand = brand
    self.model = model
    @year = year
    self.color = color
    self.speed = 0
    @@vehicle_number += 1
  end

  def self.how_many
    @@vehicle_number
  end

  def to_s
    "I am a #{self.year} #{color} #{self.brand} #{self.model} moving at #{self.speed} mph."
  end

  def speed_up(mph = 20)
    puts "Speeding up..."
    self.speed = self.speed + mph
  end

  def slow_down(mph = 20)
    puts "Slowing down..."
    self.speed = self.speed - mph
  end

  def stop
    puts "Breaking..."
    self.speed = 0
  end

  def spray_paint(color)
    self.color = color
  end

  def gas_mileage(miles, gallons)
    "#{(gallons.to_f / miles).round(2)} MPG"
  end

end


class MyCar < Vehicle

  WHEELS = 4

  def to_s
    super + "\nMy age is #{age}."
  end

  private

  def age
    Time.now.year - self.year
  end

end


class MyTruck < Vehicle

  WHEELS = 12

end


lexus = MyCar.new("Lexus", "CT200h", 2002, "silver")

puts lexus

# puts "My age is #{lexus.age}"

# puts "Year of production: #{lexus.year}"
# puts "Color: #{lexus.color}"

# lexus.spray_paint("bright red")
# puts "Color: #{lexus.color}"

# puts lexus.gas_mileage(17, 150)

# puts Vehicle.how_many

# lexus.speed_up
# puts lexus

# lexus.speed_up
# puts lexus

# lexus.speed_up
# puts lexus

# lexus.slow_down
# puts lexus

# lexus.speed_up
# puts lexus

# lexus.slow_down
# puts lexus

# lexus.slow_down
# puts lexus

# lexus.stop
# puts lexus















