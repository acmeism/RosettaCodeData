defmodule Cantor do
  @pos "█"
  @neg " "

  def run(lines) do
    Enum.map(0..lines, fn line ->
      segment_size = 3 ** (lines - line - 1)
      chars = (3 ** line)

      Enum.map(0..chars, fn char ->
        char
        |> Integer.digits(3)
        |> Enum.any?(fn x -> x === 1 end)
        |> case do
          true -> @neg
          false -> @pos
        end
      end)
      |> Enum.reduce([], fn el, acc -> duplicate_char(acc, el, segment_size) end)
      |> Enum.join()
      |> String.trim_trailing()
    end)
    |> Enum.filter(fn line -> line !== "" end)
  end

  def duplicate_char(acc, el, segment_size) when segment_size >= 1, do: acc ++ [String.duplicate(el, segment_size)]
  def duplicate_char(acc, _el, segment_size) when segment_size < 1, do: acc
end

Cantor.run(5) |> IO.inspect()
