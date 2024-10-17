defmodule RC do
  def hanoi(n) when 0<n and n<10, do: hanoi(n, 1, 2, 3)

  defp hanoi(1, f, _, t), do: move(f, t)
  defp hanoi(n, f, u, t) do
    hanoi(n-1, f, t, u)
    move(f, t)
    hanoi(n-1, u, f, t)
  end

  defp move(f, t), do: IO.puts "Move disk from #{f} to #{t}"
end

RC.hanoi(3)
