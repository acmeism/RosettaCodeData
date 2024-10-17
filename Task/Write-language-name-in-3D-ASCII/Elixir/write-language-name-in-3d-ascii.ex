defmodule ASCII3D do
  def decode(str) do
    Regex.scan(~r/(\d+)(\D+)/, str)
    |> Enum.map_join(fn[_,n,s] -> String.duplicate(s, String.to_integer(n)) end)
    |> String.replace("B", "\\")        # Backslash
  end
end

data = "1 12_4 2_1\n1/B2 9_1B2 1/2B 3 2_18 2_1\nB2 B8_1/ 3 B2 1/B_B4 2_6 2_2 1/B_B6 4_1
3 B7_3 4 B2/_2 1/2B_1_2 1/B_B B2/_4 1/ 3_1B\n 2 B2 6_1B3 3 B2 1/B2 B1/_/B_B3/ 2 1/2B 1 /B B2_1/
2 3 B5_1/4 6 B3 1B/_/2 /1_2 6 B1\n3 3 B10_6 B3 3 /2B_1_6 B1
4 2 B11_2B 1B_B2 B1_B 3 /1B/_/B_B2 B B_B1\n6 1B/11_1/3  B/_/2 3  B/_/"
IO.puts ASCII3D.decode(data)
