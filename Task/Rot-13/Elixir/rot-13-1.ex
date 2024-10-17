defmodule RC do
  def rot13(clist) do
    f = fn(c) when (?A <= c and c <= ?M) or (?a <= c and c <= ?m) -> c + 13
          (c) when (?N <= c and c <= ?Z) or (?n <= c and c <= ?z) -> c - 13
          (c) -> c
        end
    Enum.map(clist, f)
  end
end

IO.inspect encode = RC.rot13('Rosetta Code')
IO.inspect RC.rot13(encode)
