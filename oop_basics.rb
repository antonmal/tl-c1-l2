
module Meowable

  def meow(num)
    num.times { puts "Meooooow!" }
  end

end

class Animal

  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def speak
    "Hi! Not sure who I am, so I just speak like a human."
  end

end

class Cat < Animal

  include Meowable

  attr_accessor :color

  def initialize(name, color)
    super(name)
    self.color = color
  end

  def speak
    super.upcase + "\nAt least I know my name is #{self.name} and my color is #{color}."
  end

  def instance_of?(class_name)
    "I am a fake instance_of method. Ha-ha! :-("
  end

end


class GoodDog < Animal

  attr_accessor :name, :height, :weight, :age
  @@number_of_dogs = 0
  DOG_YEARS = 7

  def initialize(n, h, w, a)
    # DOG_YEARS = 30
    self.name = n
    self.height = h
    self.weight = w
    self.age = a * DOG_YEARS
    @@number_of_dogs += 1
  end

  def change_info(n, h, w, a)
    self.name = n
    self.height = h
    self.weight = w
    self.age = a * DOG_YEARS
  end

  def self.get_number_of_dogs
    @@number_of_dogs
  end

  def self.who_am_i
    puts "I am the GoodDog class"
  end

  def to_s
    "My name is #{self.name}. I am #{age} years old, #{self.height}cm of height and I weigh all #{self.weight} kilos."
  end

  def speak(phrase)
    puts "#{self.name} says: '#{phrase}'"
  end

  # def what_is_self
  #   self
  # end
end


kitty = Cat.new("Kitty", "red")

puts Animal.ancestors
puts
puts Cat.ancestors
puts
puts GoodDog.ancestors

# puts kitty.speak

# kitty.meow(5)

# puts kitty.instance_of? Cat
# puts kitty.instance_of? Animal
# puts kitty.instance_of? Object


# sparky =  GoodDog.new("Sparky", 55, 7.5, 5)
# puts sparky.speak("Woof! I am a #{sparky.class}")

# def sparky.speak
#   "Hello! I am #{self.name}."
#   # sparky.name is not available, only self.name
# end

# fido = GoodDog.new("Fido", 23, 5, 3)

# puts sparky.speak

# puts fido.speak("????")

