defmodule Knuth do
  def shuffle( inputs ) do
    n = length( inputs )
    {[], acc} = Enum.reduce( n..1, {inputs, []}, &random_move/2 )
    acc
  end

  defp random_move( n, {inputs, acc} ) do
    item = Enum.at( inputs, :rand.uniform(n)-1 )
    {List.delete( inputs, item ), [item | acc]}
  end
end

seq = Enum.to_list( 0..19 )
IO.inspect Knuth.shuffle( seq )

seq = [1,2,3]
Enum.reduce(1..100000, Map.new, fn _,acc ->
  k = Knuth.shuffle(seq)
  Map.update(acc, k, 1, &(&1+1))
end)
|> Enum.each(fn {k,v} -> IO.inspect {k,v} end)
