# creating a struct

Person = Struct.new(:name, :age, :sex)

a = Person.new("Peter", 15, :Man)
p a[0]              #=> "Peter"
p a[:age]           #=> 15
p a.sex             #=> :Man
p a.to_a            #=> ["Peter", 15, :Man]
p a.to_h            #=> {:name=>"Peter", :age=>15, :sex=>:Man}

b = Person.new
p b                 #=> #<struct Person name=nil, age=nil, sex=nil>
b.name = "Margaret"
b["age"] = 18
b[-1] = :Woman
p b.values          #=> ["Margaret", 18, :Woman]
p b.members         #=> [:name, :age, :sex]
p b.size            #=> 3

c = Person["Daniel", 22, :Man]
p c.to_h            #=> {:name=>"Daniel", :age=>22, :sex=>:Man}
