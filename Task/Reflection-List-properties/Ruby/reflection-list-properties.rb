class Foo
  @@xyz = nil
  def initialize(name, age)
    @name, @age = name, age
  end
  def add_sex(sex)
    @sex = sex
  end
end

p foo = Foo.new("Angel", 18)            #=> #<Foo:0x0000000305a688 @name="Angel", @age=18>
p foo.instance_variables                #=> [:@name, :@age]
p foo.instance_variable_defined?(:@age) #=> true
p foo.instance_variable_get(:@age)      #=> 18
p foo.instance_variable_set(:@age, 19)  #=> 19
p foo                                   #=> #<Foo:0x0000000305a688 @name="Angel", @age=19>
foo.add_sex(:woman)
p foo.instance_variables                #=> [:@name, :@age, :@sex]
p foo                                   #=> #<Foo:0x0000000305a688 @name="Angel", @age=19, @sex=:woman>
foo.instance_variable_set(:@bar, nil)
p foo.instance_variables                #=> [:@name, :@age, :@sex, :@bar]

p Foo.class_variables                   #=> [:@@xyz]
p Foo.class_variable_defined?(:@@xyz)   #=> true
p Foo.class_variable_get(:@@xyz)        #=> nil
p Foo.class_variable_set(:@@xyz, :xyz)  #=> :xyz
p Foo.class_variable_get(:@@xyz)        #=> :xyz
p Foo.class_variable_set(:@@abc, 123)   #=> 123
p Foo.class_variables                   #=> [:@@xyz, :@@abc]
