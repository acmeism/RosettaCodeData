defmodule RC do
  def ordinalize(n) do
    num = abs(n)
    ordinal = if rem(num, 100) in 4..20 do
                "th"
              else
                case rem(num, 10) do
                  1 -> "st"
                  2 -> "nd"
                  3 -> "rd"
                  _ -> "th"
                end
              end
    "#{n}#{ordinal}"
  end
end

Enum.each([0..25, 250..265, 1000..1025], fn range ->
  Enum.map(range, fn n -> RC.ordinalize(n) end) |> Enum.join(" ") |> IO.puts
end)
