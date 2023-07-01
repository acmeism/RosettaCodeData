defmodule RC do
  def anynacci(start_sequence, count) do
    n = length(start_sequence)
    anynacci(Enum.reverse(start_sequence), count-n, n)
  end

  def anynacci(seq, 0, _), do: Enum.reverse(seq)
  def anynacci(seq, count, n) do
    next = Enum.sum(Enum.take(seq, n))
    anynacci([next|seq], count-1, n)
  end
end

IO.inspect RC.anynacci([1,1], 15)

naccis = [ lucus:      [2,1],
           fibonacci:  [1,1],
           tribonacci: [1,1,2],
           tetranacci: [1,1,2,4],
           pentanacci: [1,1,2,4,8],
           hexanacci:  [1,1,2,4,8,16],
           heptanacci: [1,1,2,4,8,16,32],
           octonacci:  [1,1,2,4,8,16,32,64],
           nonanacci:  [1,1,2,4,8,16,32,64,128],
           decanacci:  [1,1,2,4,8,16,32,64,128,256] ]
Enum.each(naccis, fn {name, list} ->
  :io.format("~11s: ", [name])
  IO.inspect RC.anynacci(list, 15)
end)
