Person = Struct.new(:name,:value) do
  def to_s; "name:#{name}, value:#{value}" end
end

list = [Person.new("Joe",3),
        Person.new("Bill",4),
        Person.new("Alice",20),
        Person.new("Harry",3)]
puts list.sort_by{|x|x.name}
puts
puts list.sort_by(&:value)
