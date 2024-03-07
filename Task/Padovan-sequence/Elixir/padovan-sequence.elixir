# Padovan sequence as a Stream
defmodule Padovan do
  def stream do
    Stream.resource(
      fn -> {1, 1, 1} end,
      fn {a, b, c} ->
        next_value = a + b
        {[a], {b, c, next_value}}
      end,
      fn _ -> :ok end
    )
  end
end

# Padovan floor function
defmodule PadovanFloorFunction do
  @p 1.324717957244746025960908854
  @s 1.0453567932525329623

  def padovan_f(n), do: trunc((:math.pow(@p, n - 1) / @s) + 0.5)
end

# Calculate and print the first 20 elements of the Padovan sequence and the floor function
padovan_sequence = Padovan.stream() |> Enum.take(20)
padovan_floor_function = Enum.map(0..19, &PadovanFloorFunction.padovan_f(&1))

IO.puts("Recurrence Padovan: #{inspect(padovan_sequence)}")
IO.puts("Floor function:     #{inspect(padovan_floor_function)}")

# Check if the sequences are equal up to n
n = 63
bool = Enum.map(0..(n-1), &PadovanFloorFunction.padovan_f(&1)) == Padovan.stream() |> Enum.take(n)
IO.puts("Recurrence and floor function are equal up to #{n}: #{bool}.")

# L-system generator as a Stream
defmodule LSystem do
  def stream(axiom \\ "A", rules \\ %{"A" => "B", "B" => "C", "C" => "AB"}) do
    Stream.iterate(axiom, fn string ->
      string
      |> String.graphemes()
      |> Enum.map(&Map.get(rules, &1, ""))
      |> Enum.join()
    end)
  end
end

# Calculate and print the first 10 elements of the L-system
l_system_sequence = LSystem.stream() |> Enum.take(10)
IO.puts("First 10 elements of L-system: #{l_system_sequence |> Enum.join(", ")}")

# Check if the sizes of the L-system strings match the Padovan sequence
n = 32
l_system_sizes = LSystem.stream() |> Enum.take(n) |> Enum.map(&String.length/1)
bool = l_system_sizes == Padovan.stream() |> Enum.take(n)
IO.puts("Sizes of first #{n} L_system strings equal to recurrence Padovan? #{bool}.")
