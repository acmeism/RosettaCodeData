defmodule RC do
  def nth_root(n, x, precision \\ 1.0e-5) do
    f = fn(prev) -> ((n - 1) * prev + x / :math.pow(prev, (n-1))) / n end
    fixed_point(f, x, precision, f.(x))
  end

  defp fixed_point(_, guess, tolerance, next) when abs(guess - next) < tolerance, do: next
  defp fixed_point(f, _, tolerance, next), do: fixed_point(f, next, tolerance, f.(next))
end

Enum.each([{2, 2}, {4, 81}, {10, 1024}, {1/2, 7}], fn {n, x} ->
  IO.puts "#{n} root of #{x} is #{RC.nth_root(n, x)}"
end)
