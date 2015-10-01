class Greeting
  def greet(message)
    puts "=> #{message}"
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end

  def self.hi
    Greeting.new.greet("Hi!!!!!")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

h = Hello.new
h.hi

Hello.hi