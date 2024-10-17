defmodule Statistics do
  def basic(n) do
    {sum, sum2, hist} = generate(n)
    mean = sum / n
    stddev = :math.sqrt(sum2 / n - mean*mean)

    IO.puts "size:   #{n}"
    IO.puts "mean:   #{mean}"
    IO.puts "stddev: #{stddev}"
    Enum.each(0..9, fn i ->
      :io.fwrite "~.1f:~s~n", [0.1*i, String.duplicate("=", trunc(500 * hist[i] / n))]
    end)
    IO.puts ""
  end

  defp generate(n) do
    hist = for i <- 0..9, into: %{}, do: {i,0}
    Enum.reduce(1..n, {0, 0, hist}, fn _,{sum, sum2, h} ->
      r = :rand.uniform
      {sum+r, sum2+r*r, Map.update!(h, trunc(10*r), &(&1+1))}
    end)
  end
end

Enum.each([100,1000,10000], fn n ->
  Statistics.basic(n)
end)
