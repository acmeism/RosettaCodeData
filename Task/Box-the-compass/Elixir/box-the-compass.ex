defmodule Box do
  defp head do
    Enum.chunk(~w(north east south west north), 2, 1)
    |> Enum.flat_map(fn [a,b] ->
         c = if a=="north" or a=="south", do: "#{a}#{b}", else: "#{b}#{a}"
         [ a, "#{a} by #{b}", "#{a}-#{c}", "#{c} by #{a}",
           c, "#{c} by #{b}", "#{b}-#{c}", "#{b} by #{a}" ]
       end)
    |> Enum.with_index
    |> Enum.map(fn {s, i} -> {i+1, String.capitalize(s)} end)
    |> Map.new
  end

  def compass do
    header = head()
    angles = Enum.map(0..32, fn i -> i * 11.25 + elem({0, 5.62, -5.62}, rem(i, 3)) end)
    Enum.each(angles, fn degrees ->
      index = rem(round(32 * degrees / 360), 32) + 1
      :io.format "~2w  ~-20s ~6.2f~n", [index, header[index], degrees]
    end)
  end
end

Box.compass
