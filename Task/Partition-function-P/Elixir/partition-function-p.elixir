use Bitwise, skip_operators: true

defmodule Partition do
   def init(), do:
      :ets.new :pN, [:set, :named_table, :private]

   def gpentagonals(), do: Stream.unfold {1, 0}, &next/1
   defp next({m, n}) do
      a = case rem m, 2 do
             0 -> div m, 2
             1 -> m
          end
      {n, {m + 1, n + a}}
   end

   def p(0), do: 1
   def p(n) do
      case :ets.lookup :pN, n do
         [{^n, val}] -> val
         [] ->
            {val, _} = gpentagonals()
                       |> Stream.drop(1)
                       |> Stream.take_while(fn m -> m <= n end)
                       |> Stream.map(fn g -> p(n - g) end)
                       |> Enum.reduce({0, 0},
                              fn n, {a, sgn} -> {
                                          a + (if sgn < 2, do: n, else: -n),
                                          band(sgn + 1, 3)
                                          }
                              end)
            :ets.insert :pN, {n, val}
            val
      end
   end
end

Partition.init
IO.puts Partition.p 6666
