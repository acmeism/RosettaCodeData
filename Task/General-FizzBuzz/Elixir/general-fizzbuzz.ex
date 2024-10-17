defmodule General do
  def fizzbuzz(input) do
    [num | nwords] = String.split(input)
    max = String.to_integer(num)
    dict = Enum.chunk(nwords, 2) |> Enum.map(fn[n,word] -> {String.to_integer(n),word} end)
    Enum.each(1..max, fn i ->
      str = Enum.map_join(dict, fn {n,word} -> if rem(i,n)==0, do: word end)
      IO.puts if str=="", do: i, else: str
    end)
  end
end

input = """
105
3 Fizz
5 Buzz
7 Baxx
"""
General.fizzbuzz(input)
