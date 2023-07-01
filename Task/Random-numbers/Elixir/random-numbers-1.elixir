defmodule Random do
  def normal(mean, sd) do
    {a, b} = {:rand.uniform, :rand.uniform}
    mean + sd * (:math.sqrt(-2 * :math.log(a)) * :math.cos(2 * :math.pi * b))
  end
end

std_dev = fn (list) ->
            mean = Enum.sum(list) / length(list)
            sd = Enum.reduce(list, 0, fn x,acc -> acc + (x-mean)*(x-mean) end) / length(list)
                 |> :math.sqrt
            IO.puts "Mean: #{mean},\tStdDev: #{sd}"
          end

xs = for _ <- 1..1000, do: Random.normal(1.0, 0.5)
std_dev.(xs)
