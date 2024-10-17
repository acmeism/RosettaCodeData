defmodule PrimesSoEMap do
  @typep stt :: {integer, integer, integer, Enumerable.integer, %{integer => integer}}

  @spec advance(stt) :: stt
  defp advance {n, bp, q, bps?, map} do
    bps = if bps? === nil do Stream.drop(oddprms(), 1) else bps? end
    nn = n + 2
    if nn >= q do
      inc = bp + bp
      nbps = bps |> Stream.drop(1)
      [nbp] = nbps |> Enum.take(1)
      advance {nn, nbp, nbp * nbp, nbps, map |> Map.put(nn + inc, inc)}
    else if Map.has_key?(map, nn) do
      {inc, rmap} = Map.pop(map, nn)
      [next] =
        Stream.iterate(nn + inc, &(&1 + inc))
          |> Stream.drop_while(&(Map.has_key?(rmap, &1))) |> Enum.take(1)
      advance {nn, bp, q, bps, Map.put(rmap, next, inc)}
    else
      {nn, bp, q, bps, map}
    end end
  end

  @spec oddprms() :: Enumerable.integer
  defp oddprms do # put first base prime cull seq in Map so never empty
    # advance base odd primes to 5 when initialized
    init = {7, 5, 25, nil, %{9 => 6}}
    [3, 5] # to avoid race, preseed with the first 2 elements...
      |> Stream.concat(
            Stream.iterate(init, &(advance &1))
              |> Stream.map(fn {p,_,_,_,_} -> p end))
  end

  @spec primes() :: Enumerable.integer
  def primes do
    Stream.concat([2], oddprms())
  end

end

IO.write "The first 20 primes are:\n( "
PrimesSoEMap.primes() |> Stream.take(20) |> Enum.each(&(IO.write "#{&1} "))
IO.puts ")"
IO.write "The primes between 100 to 150 are:\n( "
PrimesSoEMap.primes() |> Stream.drop_while(&(&1<100))
  |> Stream.take_while(&(&1<150)) |> Enum.each(&(IO.write "#{&1} "))
IO.puts ")"
IO.write "The number of primes between 7700 and 8000 is:  "
PrimesSoEMap.primes() |> Stream.drop_while(&(&1<7700))
  |> Stream.take_while(&(&1<8000)) |> Enum.count |> IO.puts
IO.write "The 10,000th prime is:  "
PrimesSoEMap.primes() |> Stream.drop(9999)
  |> Enum.take(1) |> List.first |>IO.puts
IO.write "The sum of all the priems to two million is:  "
testfunc =
  fn () ->
    ans =
      PrimesSoEMap.primes() |> Stream.take_while(&(&1<=2000000))
        |> Enum.sum() |> IO.puts
    ans end
:timer.tc(testfunc)
  |> (fn {t,_} ->
    IO.puts "This test bench took #{t} microseconds." end).()
