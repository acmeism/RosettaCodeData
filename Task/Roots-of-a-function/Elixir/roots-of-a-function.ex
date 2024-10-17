defmodule RC do
  def find_roots(f, range, step \\ 0.001) do
    first .. last = range
    max = last + step / 2
    Stream.iterate(first, &(&1 + step))
    |> Stream.take_while(&(&1 < max))
    |> Enum.reduce(sign(first), fn x,sn ->
         value = f.(x)
         cond do
           abs(value) < step / 100 ->
             IO.puts "Root found at #{x}"
             0
           sign(value) == -sn ->
             IO.puts "Root found between #{x-step} and #{x}"
             -sn
           true -> sign(value)
         end
       end)
  end

  defp sign(x) when x>0, do: 1
  defp sign(x) when x<0, do: -1
  defp sign(0)         , do: 0
end

f = fn x -> x*x*x - 3*x*x + 2*x end
RC.find_roots(f, -1..3)
