defmodule Middle do
  def three(num) do
    n = num |> abs |> to_string

    case {n,String.length(n) > 2,even?(n)} do
      {n, true, false} ->
        cut(n)
      {_, false, _} ->
        raise "Number must have at least three digits"
      {_, _, true} ->
        raise "Number must have an odd number of digits"
    end
  end

  defp even?(n), do: rem(String.length(n),2) == 0
  defp cut(n), do: String.slice(n,(div(String.length(n),2) - 1),3)
end

valids = [123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345]
Enum.each(valids, fn n -> :io.format "~10w : ~s~n", [n, Middle.three(n)] end)

errors = [1, 2, -1, -10, 2002, -2002, 0]
Enum.each(errors, fn n ->
  :io.format "~10w : ", [n]
  try do
    IO.puts Middle.three(n)
  rescue
    e -> IO.puts e.message
  end
end)
