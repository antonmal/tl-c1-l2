class Greeting
  def greet(msg)
    puts "=> #{msg}"
  end
end

class Hello < Greeting
  def hello
    greet("Hello!")
  end
end

class GoodBye < Greeting
  def bye
    greet("Bye-bye!")
  end
end

Hello.new.hello

GoodBye.new.bye