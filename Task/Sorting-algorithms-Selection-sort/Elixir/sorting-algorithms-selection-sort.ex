defmodule Sort do
  def selection_sort(list) when is_list(list), do: selection_sort(list, [])

  defp selection_sort([], sorted), do: sorted
  defp selection_sort(list, sorted) do
    max = Enum.max(list)
    selection_sort(List.delete(list, max), [max | sorted])
  end
end
