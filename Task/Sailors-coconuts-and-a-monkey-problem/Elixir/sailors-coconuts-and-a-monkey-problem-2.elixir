defmodule Sailor do
  def coconuts(sailor), do: coconuts(sailor, sailor)
  defp coconuts(sailor, nuts) do
    if n = do_coconuts(sailor, nuts, sailor), do: n, else: coconuts(sailor, nuts+sailor)
  end

  defp do_coconuts(_sailor, nuts, 0), do: nuts
  defp do_coconuts(sailor, nuts, _) when rem(nuts, sailor-1) != 0, do: nil
  defp do_coconuts(sailor, nuts, i) do
    do_coconuts(sailor, nuts + div(nuts, sailor-1) + 1, i-1)
  end
end

Enum.each(2..9, fn sailor ->
  IO.puts "#{sailor}: #{Sailor.coconuts(sailor)}"
end)
