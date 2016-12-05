defmodule Loops do
  def break, do: break(random)

  defp break(10), do: IO.puts 10
  defp break(r) do
    IO.puts "#{r},\t#{random}"
    break(random)
  end

  defp random, do: Enum.random(0..19)
end

Loops.break
