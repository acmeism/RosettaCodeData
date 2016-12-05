class Example
  def initialize
     @private_data = "nothing" # instance variables are always private
  end
  private
  def hidden_method
     "secret"
  end
end
example = Example.new
p example.private_methods(false) # => [:hidden_method]
#p example.hidden_method # => NoMethodError: private method `name' called for #<Example:0x101308408>
p example.send(:hidden_method) # => "secret"
p example.instance_variables # => [:@private_data]
p example.instance_variable_get :@private_data # => "nothing"
p example.instance_variable_set :@private_data, 42 # => 42
p example.instance_variable_get :@private_data # => 42
