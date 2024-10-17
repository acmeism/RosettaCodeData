defmodule Statistics do
  def normal_distribution(n, w\\5) do
    {sum, sum2, hist} = generate(n, w)
    mean = sum / n
    stddev = :math.sqrt(sum2 / n - mean*mean)

    IO.puts "size:   #{n}"
    IO.puts "mean:   #{mean}"
    IO.puts "stddev: #{stddev}"
    {min, max} = Map.to_list(hist)
                 |> Enum.filter_map(fn {_k,v} -> v >= n/120/w end, fn {k,_v} -> k end)
                 |> Enum.min_max
    Enum.each(min..max, fn i ->
      bar = String.duplicate("=", trunc(120 * w * Map.get(hist, i, 0) / n))
      :io.fwrite "~4.1f: ~s~n", [i/w, bar]
    end)
    IO.puts ""
  end

  defp generate(n, w) do
    Enum.reduce(1..n, {0, 0, %{}}, fn _,{sum, sum2, hist} ->
      z = :rand.normal
      {sum+z, sum2+z*z, Map.update(hist, round(w*z), 1, &(&1+1))}
    end)
  end
end

Enum.each([100,1000,10000], fn n ->
  Statistics.normal_distribution(n)
end)
