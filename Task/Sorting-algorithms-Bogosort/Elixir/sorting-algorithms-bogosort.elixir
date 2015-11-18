defmodule Sort do
  def bogo_sort(list) do
    if sorted?(list) do
      list
    else
      bogo_sort(Enum.shuffle(list))
    end
  end

  defp sorted?(list) when length(list)<=1, do: true
  defp sorted?([x, y | _]) when x>y, do: false
  defp sorted?([_, y | rest]), do: sorted?([y | rest])
end
