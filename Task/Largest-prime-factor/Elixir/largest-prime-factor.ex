defmodule Factor do
   def wheel235(), do:
      Stream.concat(
         [2, 3, 5],
         Stream.scan(Stream.cycle([6, 4, 2, 4, 2, 4, 6, 2]), 1, &+/2)
      )

   def gpf(n), do: gpf n, wheel235()
   defp gpf(n, divs) do
      [d] = Enum.take divs, 1
      cond do
         d*d > n -> n
         rem(n, d) === 0 -> gpf div(n, d), divs
         true -> gpf n, Stream.drop(divs, 1)
      end
   end
end

IO.puts "The largest prime factor of 600,851,475,143 is #{Factor.gpf(600_851_475_143)}"
