defmodule RC do
  def run(list, gen \\ 0) do
    print(list, gen)
    next = evolve(list)
    if next == list, do: print(next, gen+1), else: run(next, gen+1)
  end

  defp evolve(list), do: evolve(Enum.concat([[0], list, [0]]), [])

  defp evolve([a,b,c],      next), do: Enum.reverse([life(a,b,c) | next])
  defp evolve([a,b,c|rest], next), do: evolve([b,c|rest], [life(a,b,c) | next])

  defp life(a,b,c), do: (if a+b+c == 2, do: 1, else: 0)

  defp print(list, gen) do
    str = "Generation #{gen}: "
    IO.puts Enum.reduce(list, str, fn x,s -> s <> if x==0, do: ".", else: "#" end)
  end
end

RC.run([0,1,1,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,0])
