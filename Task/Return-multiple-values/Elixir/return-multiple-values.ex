defmodule RC do
  def addsub(a, b) do
    {a+b, a-b}
  end
end

{add, sub} = RC.addsub(7, 4)
IO.puts "Add: #{add},\tSub: #{sub}"
