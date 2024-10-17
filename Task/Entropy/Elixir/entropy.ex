defmodule RC do
  def entropy(str) do
    leng = String.length(str)
    String.graphemes(str)
    |> Enum.group_by(&(&1))
    |> Enum.map(fn{_,value} -> length(value) end)
    |> Enum.reduce(0, fn count, entropy ->
         freq = count / leng
         entropy - freq * :math.log2(freq)
       end)
  end
end

IO.inspect RC.entropy("1223334444")
