class Student

  attr_accessor :name

  def initialize(name, grade)
    self.name = name
    @grade = grade
  end

  def better_grade_than?(classmate)
    @grade > classmate.grade
  end

  protected

  def grade
    @grade
  end

end


bob = Student.new("Bob", 100)
john = Student.new("Johny", 98)

puts bob.better_grade_than?(john)

# puts bob.grade

p bob.instance_variable_get("@grade")