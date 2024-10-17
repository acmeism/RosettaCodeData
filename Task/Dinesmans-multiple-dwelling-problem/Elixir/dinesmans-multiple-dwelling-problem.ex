defmodule Dinesman do
  def problem do
    names = ~w( Baker Cooper Fletcher Miller Smith )a
    predicates = [fn(c)-> :Baker != List.last(c) end,
                  fn(c)-> :Cooper != List.first(c) end,
                  fn(c)-> :Fletcher != List.first(c) && :Fletcher != List.last(c) end,
                  fn(c)-> floor(c, :Miller) > floor(c, :Cooper) end,
                  fn(c)-> abs(floor(c, :Smith) - floor(c, :Fletcher)) != 1 end,
                  fn(c)-> abs(floor(c, :Cooper) - floor(c, :Fletcher)) != 1 end]

    permutation(names)
    |> Enum.filter(fn candidate ->
         Enum.all?(predicates, fn predicate -> predicate.(candidate) end)
       end)
    |> Enum.each(fn name_list ->
         Enum.with_index(name_list)
         |> Enum.each(fn {name,i} -> IO.puts "#{name} lives on #{i+1}" end)
       end)
  end

  defp floor(c, name), do: Enum.find_index(c, fn x -> x == name end)

  defp permutation([]), do: [[]]
  defp permutation(list), do: (for x <- list, y <- permutation(list -- [x]), do: [x|y])
end

Dinesman.problem
