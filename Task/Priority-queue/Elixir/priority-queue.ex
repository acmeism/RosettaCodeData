defmodule Priority do
  def create, do: :gb_trees.empty

  def insert( element, priority, queue ), do: :gb_trees.enter( priority, element, queue )

  def peek( queue ) do
    {_priority, element, _new_queue} = :gb_trees.take_smallest( queue )
    element
  end

  def task do
    items = [{3, "Clear drains"}, {4, "Feed cat"}, {5, "Make tea"}, {1, "Solve RC tasks"}, {2, "Tax return"}]
    queue = Enum.reduce(items, create, fn({priority, element}, acc) -> insert( element, priority, acc ) end)
    IO.puts "peek priority: #{peek( queue )}"
    Enum.reduce(1..length(items), queue, fn(_n, q) -> write_top( q ) end)
  end

  def top( queue ) do
    {_priority, element, new_queue} = :gb_trees.take_smallest( queue )
    {element, new_queue}
  end

  defp write_top( q ) do
    {element, new_queue} = top( q )
    IO.puts "top priority: #{element}"
    new_queue
  end
end

Priority.task
