defmodule RC do
  @small  ~w(zero one two three four five six seven eight nine ten
             eleven twelve thirteen fourteen fifteen sixteen seventeen
             eighteen nineteen)
  @tens  ~w(wrong wrong twenty thirty forty fifty sixty seventy eighty ninety)
  @big  [nil, "thousand"] ++
        (~w( m b tr quadr quint sext sept oct non dec) |> Enum.map(&"#{&1}illion"))

  def wordify(number) when number<0, do: "negative #{wordify(-number)}"
  def wordify(number) when number<20, do: Enum.at(@small,number)
  def wordify(number) when number<100 do
    rm = rem(number,10)
    Enum.at(@tens,div(number,10)) <> (if rm==0, do: "", else: "-#{wordify(rm)}")
  end
  def wordify(number) when number<1000 do
    rm = rem(number,100)
    "#{Enum.at(@small,div(number,100))} hundred" <> (if rm==0, do: "", else: " and #{wordify(rm)}")
  end
  def wordify(number) do
    # separate into 3-digit chunks
    chunks = chunk(number, [])
    if length(chunks) > length(@big), do: raise(ArgumentError, "Integer value too large.")
    Enum.map(chunks, &wordify(&1))
    |> Enum.zip(@big)
    |> Enum.filter_map(fn {a,_} -> a != "zero" end, fn {a,b} -> "#{a} #{b}" end)
    |> Enum.reverse
    |> Enum.join(", ")
  end

  defp chunk(0, res), do: Enum.reverse(res)
  defp chunk(number, res) do
    chunk(div(number,1000), [rem(number,1000) | res])
  end
end

data = [-1123, 0, 1, 20, 123, 200, 220, 1245, 2000, 2200, 2220, 467889,
        23_000_467, 23_234_467, 2_235_654_234, 12_123_234_543_543_456,
        987_654_321_098_765_432_109_876_543_210_987_654,
        123890812938219038290489327894327894723897432]

Enum.each(data, fn n ->
  IO.write "#{n}: "
  try do
    IO.inspect RC.wordify(n)
  rescue
    e in ArgumentError -> IO.puts Exception.message(e)
  end
end)
