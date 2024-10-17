defmodule Knuth do
  def s_of_n_creator(n), do: {n, 1, []}

  def s_of_n({n, i, ys}, x) do
    cond do
      i <= n -> {n, i+1, [x|ys]}

      :rand.uniform(i) <= n ->
        {n, i+1, List.replace_at(ys, :rand.uniform(n)-1, x)}

      true -> {n, i+1, ys}
    end
  end
end

results = Enum.reduce(1..100000, %{}, fn _, freq ->
  {_, _, xs} = Enum.reduce(1..10, Knuth.s_of_n_creator(3), fn x, s ->
    Knuth.s_of_n(s, x)
  end)
  Enum.reduce(xs, freq, fn x, freq ->
    Map.put(freq, x, (freq[x] || 0) + 1)
  end)
end)

IO.inspect results
