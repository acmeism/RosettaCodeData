defmodule RC do
  def entropy(str) do
    leng = String.length(str)
    String.to_charlist(str)
    |> Enum.reduce(Map.new, fn c,acc -> Map.update(acc, c, 1, &(&1+1)) end)
    |> Map.values
    |> Enum.reduce(0, fn count, entropy ->
         freq = count / leng
         entropy - freq * :math.log2(freq)      # log2 was added with Erlang/OTP 18
       end)
  end
end

fibonacci_word = Stream.unfold({"1","0"}, fn{a,b} -> {a, {b, b<>a}} end)

IO.puts "  N    Length       Entropy       Fibword"
fibonacci_word |> Enum.take(37) |> Enum.with_index
|> Enum.each(fn {word,i} ->
  len = String.length(word)
  str = if len < 60, do: word, else: "<too long>"
  :io.format "~3w  ~8w  ~17.15f  ~s~n", [i+1, len, RC.entropy(word), str]
end)
