# Anonymous function

foo = fn() ->
  IO.puts("foo")
end

foo()  #=> undefined function foo/0
foo.() #=> "foo"

# Using `def`

defmodule Foo do
  def foo do
    IO.puts("foo")
  end
end

Foo.foo    #=> "foo"
Foo.foo()  #=> "foo"


# Calling a function with a fixed number of arguments

defmodule Foo do
  def foo(x) do
    IO.puts(x)
  end
end

Foo.foo("foo") #=> "foo"

# Calling a function with a default argument

defmodule Foo do
  def foo(x \\ "foo") do
    IO.puts(x)
  end
end

Foo.foo()      #=> "foo"
Foo.foo("bar") #=> "bar"

# There is no such thing as a function with a variable number of arguments. So in Elixir, you'd call the function with a list

defmodule Foo do
  def foo(args) when is_list(args) do
    Enum.each(args, &(IO.puts(&1)))
  end
end

# Calling a function with named arguments

defmodule Foo do
  def foo([x: x]) do
    IO.inspect(x)
  end
end
