defmodule U0, do: defexception [:message]
defmodule U1, do: defexception [:message]

defmodule ExceptionsTest do
  def foo do
    Enum.each([0,1], fn i ->
      try do
        bar(i)
      rescue
        U0 -> IO.puts "U0 rescued"
      end
    end)
  end

  def bar(i), do: baz(i)

  def baz(0), do: raise U0
  def baz(1), do: raise U1
end

ExceptionsTest.foo
