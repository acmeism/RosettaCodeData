defmodule Word_wrap do
  def paragraph( string, max_line_length ) do
    [word | rest] = String.split( string, ~r/\s+/, trim: true )
    lines_assemble( rest, max_line_length, String.length(word), word, [] )
      |> Enum.join( "\n" )
  end

  defp lines_assemble( [], _, _, line, acc ), do: [line | acc] |> Enum.reverse
  defp lines_assemble( [word | rest], max, line_length, line, acc ) do
    if line_length + 1 + String.length(word) > max do
      lines_assemble( rest, max, String.length(word), word, [line | acc] )
    else
      lines_assemble( rest, max, line_length + 1 + String.length(word), line <> " " <> word, acc )
    end
  end
end

text = """
Even today, with proportional fonts and complex layouts, there are still cases where you need to
wrap text at a specified column. The basic task is to wrap a paragraph of text in a simple way in
your language. If there is a way to do this that is built-in, trivial, or provided in a standard
library, show that. Otherwise implement the minimum length greedy algorithm from Wikipedia.
"""
Enum.each([72, 80], fn len ->
  IO.puts String.duplicate("-", len)
  IO.puts Word_wrap.paragraph(text, len)
end)
