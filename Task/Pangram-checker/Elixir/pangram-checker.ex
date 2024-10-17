defmodule Pangram do
  def checker(str) do
    unused = Enum.to_list(?a..?z) -- to_char_list(String.downcase(str))
    Enum.empty?(unused)
  end
end

text = "The quick brown fox jumps over the lazy dog."
IO.puts "#{Pangram.checker(text)}\t#{text}"
text = (Enum.to_list(?A..?Z) -- 'Test') |> to_string
IO.puts "#{Pangram.checker(text)}\t#{text}"
