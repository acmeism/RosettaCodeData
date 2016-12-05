defmodule RC do
  def factorial(0), do: 1
  def factorial(n), do: Enum.reduce(1..n, 1, &(&1 * &2))

  def loop_length(n), do: loop_length(n, MapSet.new)

  defp loop_length(n, set) do
    r = :rand.uniform(n)
    if r in set, do: MapSet.size(set), else: loop_length(n, MapSet.put(set, r))
  end

  def task(runs) do
    IO.puts " N    average   analytical   (error) "
    IO.puts "===  =========  ==========  ========="
    Enum.each(1..20, fn n ->
      avg = Enum.reduce(1..runs, 0, fn _,sum -> sum + loop_length(n) end) / runs
      analytical = Enum.reduce(1..n, 0, fn i,sum ->
        sum + (factorial(n) / :math.pow(n, i) / factorial(n-i))
      end)
      :io.format "~3w  ~9.4f   ~9.4f  (~6.2f%)~n", [n, avg, analytical, abs(avg/analytical - 1)*100]
    end)
  end
end

runs = 1_000_000
RC.task(runs)
