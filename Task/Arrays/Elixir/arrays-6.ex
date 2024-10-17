my_list = [1, :two, "three"]
my_list ++ [4, :five]              # => [1, :two, "three", 4, :five]

List.insert_at(my_list, 0, :cool)  # => [:cool, 1, :two, "three"]
List.replace_at(my_list, 1, :cool) # => [1, :cool, "three"]
List.delete(my_list, :two)         # => [1, "three"]
my_list -- ["three", 1]            # => [:two]
my_list                            # => [1, :two, "three"]
