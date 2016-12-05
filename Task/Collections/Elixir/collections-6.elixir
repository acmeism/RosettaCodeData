defmodule User do
  defstruct name: "john", age: 27
end
john = %User{}                      #=> %User{age: 27, name: "john"}
john.name                           #=> "john"
%User{age: age} = john              #   pattern matching
age                                 #=> 27
meg = %User{name: "meg"}            #=> %User{age: 27, name: "meg"}
is_map(meg)                         #=> true
