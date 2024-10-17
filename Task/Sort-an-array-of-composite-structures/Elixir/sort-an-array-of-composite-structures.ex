defmodule Person do
  defstruct name: "", value: 0
end

list = [struct(Person, [name: "Joe", value: 3]),
        struct(Person, [name: "Bill", value: 4]),
        struct(Person, [name: "Alice", value: 20]),
        struct(Person, [name: "Harry", value: 3])]

Enum.sort(list) |> Enum.each(fn x -> IO.inspect x end)
IO.puts ""
Enum.sort_by(list, &(&1.value)) |> Enum.each(&IO.inspect &1)
