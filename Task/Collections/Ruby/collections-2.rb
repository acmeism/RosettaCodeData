# creating an empty hash

h = {}              #=> {}
h["a"] = 1          #=> {"a"=>1}
h["test"] = 2.4     #=> {"a"=>1, "test"=>2.4}
h[3] = "Hello"      #=> {"a"=>1, "test"=>2.4, 3=>"Hello"}
h = {a:1, test:2.4, World!:"Hello"}
                    #=> {:a=>1, :test=>2.4, :World!=>"Hello"}

# creating a hash with the constructor
h = Hash.new        #=> {}   (default value : nil)
p h[1]              #=> nil
h = Hash.new(0)     #=> {}   (default value : 0)
p h[1]              #=> 0
p h                 #=> {}
h = Hash.new{|hash, key| key.to_s}
                    #=> {}
p h[123]            #=> "123"
p h                 #=> {}
h = Hash.new{|hash, key| hash[key] = "foo#{key}"}
                    #=> {}
p h[1]              #=> "foo1"
p h                 #=> {1=>"foo1"}
