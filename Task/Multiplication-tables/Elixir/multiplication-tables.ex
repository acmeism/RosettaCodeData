defmodule RC do
  def multiplication_tables(n) do
    IO.write " X |"
    Enum.each(1..n, fn i -> :io.fwrite("~4B", [i]) end)
    IO.puts "\n---+" <> String.duplicate("----", n)
    Enum.each(1..n, fn j ->
      :io.fwrite("~2B |", [j])
      Enum.each(1..n, fn i ->
        if i<j, do: (IO.write "    "), else: :io.fwrite("~4B", [i*j])
      end)
      IO.puts ""
    end)
  end
end

RC.multiplication_tables(12)
