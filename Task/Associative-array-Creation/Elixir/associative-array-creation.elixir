defmodule RC do
  def test_create do
    IO.puts "< create Map.new >"
    m = Map.new                   #=> creates an empty Map
    m1 = Map.put(m,:foo,1)
    m2 = Map.put(m1,:bar,2)
    print_vals(m2)
    print_vals(%{m2 | foo: 3})
  end

  defp print_vals(m) do
    IO.inspect m
    Enum.each(m, fn {k,v} -> IO.puts "#{inspect k} => #{v}" end)
  end
end

RC.test_create
