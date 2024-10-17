defmodule Short_circuit do
  defp a(bool) do
    IO.puts "a( #{bool} ) called"
    bool
  end

  defp b(bool) do
    IO.puts "b( #{bool} ) called"
    bool
  end

  def task do
    Enum.each([true, false], fn i ->
      Enum.each([true, false], fn j ->
        IO.puts "a( #{i} ) and b( #{j} ) is #{a(i) and b(j)}.\n"
        IO.puts "a( #{i} ) or b( #{j} ) is #{a(i)  or b(j)}.\n"
      end)
    end)
  end
end

Short_circuit.task
