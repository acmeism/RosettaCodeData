defmodule Loops do
  def nested do
    list = Enum.shuffle(1..20) |> Enum.chunk(5)
    IO.inspect list, char_lists: :as_lists
    try do
      nested(list)
    catch
      :find -> IO.puts "done"
    end
  end

  def nested(list) do
    Enum.each(list, fn row ->
      Enum.each(row, fn x ->
        IO.write "#{x} "
        if x == 20, do: throw(:find)
      end)
      IO.puts ""
    end)
  end
end

Loops.nested
