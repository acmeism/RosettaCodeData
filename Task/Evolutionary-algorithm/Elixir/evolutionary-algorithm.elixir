defmodule Log do
  def show(offspring,i) do
    IO.puts "Generation: #{i}, Offspring: #{offspring}"
  end

  def found({target,i}) do
    IO.puts "#{target} found in #{i} iterations"
  end
end

defmodule Evolution do
  # char list from A to Z; 32 is the ord value for space.
  @chars  [32 | Enum.to_list(?A..?Z)]

  def select(target) do
    (1..String.length(target)) # Creates parent for generation 0.
      |> Enum.map(fn _-> Enum.random(@chars) end)
      |> mutate(to_charlist(target),0)
      |> Log.found
  end

  # w is used to denote fitness in population genetics.

  defp mutate(parent,target,i) when target == parent, do: {parent,i}
  defp mutate(parent,target,i) do
    w = fitness(parent,target)
    prev = reproduce(target,parent,mu_rate(w))

    # Check if the most fit member of the new gen has a greater fitness than the parent.
    if w < fitness(prev,target) do
      Log.show(prev,i)
      mutate(prev,target,i+1)
    else
      mutate(parent,target,i+1)
    end
  end

  # Generate 100 offspring and select the one with the greatest fitness.

  defp reproduce(target,parent,rate) do
    [parent | (for _ <- 1..100, do: mutation(parent,rate))]
      |> Enum.max_by(fn n -> fitness(n,target) end)
  end

  # Calculate fitness by checking difference between parent and offspring chars.

  defp fitness(t,r) do
    Enum.zip(t,r)
      |> Enum.reduce(0, fn {tn,rn},sum -> abs(tn - rn) + sum end)
      |> calc
  end

  # Generate offspring based on parent.

  defp mutation(p,r) do
    # Copy the parent chars, then check each val against the random mutation rate
    Enum.map(p, fn n -> if :rand.uniform <= r, do: Enum.random(@chars), else: n end)
  end

  defp calc(sum),  do: 100 * :math.exp(sum/-10)
  defp mu_rate(n), do: 1   - :math.exp(-(100-n)/400)
end

Evolution.select("METHINKS IT IS LIKE A WEASEL")
