require 'ostruct'

# creating a OpenStruct
ab = OpenStruct.new
p ab                #=> #<OpenStruct>
ab.foo = 25
p ab.foo            #=> 25
ab[:bar] = 2
p ab["bar"]         #=> 2
p ab                #=> #<OpenStruct foo=25, bar=2>
ab.delete_field("foo")
p ab.foo            #=> nil
p ab                #=> #<OpenStruct bar=2>

p son = OpenStruct.new({ :name => "Thomas", :age => 3 })
                    #=> #<OpenStruct name="Thomas", age=3>
p son.name          #=> "Thomas"
p son[:age]         #=> 3
son.age += 1
p son.age           #=> 4
son.items = ["candy","toy"]
p son.items         #=> ["candy","toy"]
p son               #=> #<OpenStruct name="Thomas", age=4, items=["candy", "toy"]
