defmodule One_of_n_lines_in_file do
  def task do
    dict = Enum.reduce(1..1000000, %{}, fn _,acc ->
      Map.update( acc, one_of_n(10), 1, &(&1+1) )
    end)
    Enum.each(Enum.sort(Map.keys(dict)), fn x ->
      :io.format "Line ~2w selected: ~6w~n", [x, dict[x]]
    end)
  end

  def one_of_n( n ), do: loop( n, 2, :rand.uniform, 1 )

  def loop( max, n, _random, acc ) when n == max + 1, do: acc
  def loop( max, n, random, _acc ) when random < (1/n), do: loop( max, n + 1, :rand.uniform, n )
  def loop( max, n, _random, acc ), do: loop( max, n + 1, :rand.uniform, acc )
end

One_of_n_lines_in_file.task
