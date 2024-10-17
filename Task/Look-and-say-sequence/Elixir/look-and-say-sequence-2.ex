defmodule RC do
  def look_and_say(n) do
    Regex.replace(~r/(.)\1*/, to_string(n), fn x,y -> [to_string(String.length(x)),y] end)
    |> String.to_integer
  end
end

IO.inspect Enum.reduce(1..9, [1], fn _,acc -> [RC.look_and_say(hd(acc)) | acc] end) |> Enum.reverse
