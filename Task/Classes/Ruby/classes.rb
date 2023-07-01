class MyClass

  def initialize
    @instance_var = 0
  end

  def add_1
    @instance_var += 1
  end

end

my_class = MyClass.new #allocates an object and calls it's initialize method, then returns it.
