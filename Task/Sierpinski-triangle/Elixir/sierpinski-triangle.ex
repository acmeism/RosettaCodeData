defmodule RC do
  def sierpinski_triangle(n) do
    f = fn(x) -> IO.puts "#{x}" end
    Enum.each(triangle(n, ["*"], " "), f)
  end

  defp triangle(0, down, _), do: down
  defp triangle(n, down, sp) do
    newDown = (for x <- down, do: sp<>x<>sp) ++ (for x <- down, do: x<>" "<>x)
    triangle(n-1, newDown, sp<>sp)
  end
end

RC.sierpinski_triangle(4)
