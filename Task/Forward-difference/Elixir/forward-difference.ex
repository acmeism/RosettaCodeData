defmodule Diff do
  def forward(list,i\\1) do
    forward(list,[],i)
  end

  def forward([_],diffs,1), do: IO.inspect diffs
  def forward([_],diffs,i), do: forward(diffs,[],i-1)
  def forward([val1,val2|vals],diffs,i) do
    forward([val2|vals],diffs++[val2-val1],i)
  end
end

Enum.each(1..9, fn i ->
  Diff.forward([90, 47, 58, 29, 22, 32, 55, 5, 55, 73],i)
end)
