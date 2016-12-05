defmodule RC do
  use Bitwise
  @bit_size 4

  def four_bit_adder(a, b) do           # returns pair {sum, carry}
    a_bits = binary_string_to_bits(a)
    b_bits = binary_string_to_bits(b)
    Enum.zip(a_bits, b_bits)
    |> List.foldr({[], 0}, fn {a_bit, b_bit}, {acc, carry} ->
         {s, c} = full_adder(a_bit, b_bit, carry)
         {[s | acc], c}
       end)
  end

  defp full_adder(a, b, c0) do
    {s, c} = half_adder(c0, a)
    {s, c1} = half_adder(s, b)
    {s, bor(c, c1)}                     # returns pair {sum, carry}
  end

  defp half_adder(a, b) do
    {bxor(a, b), band(a, b)}            # returns pair {sum, carry}
  end

  def int_to_binary_string(n) do
    Integer.to_string(n,2) |> String.rjust(@bit_size, ?0)
  end

  defp binary_string_to_bits(s) do
    String.codepoints(s) |> Enum.map(fn bit -> String.to_integer(bit) end)
  end

  def task do
    IO.puts " A    B      A      B   C    S  sum"
    Enum.each(0..15, fn a ->
      bin_a = int_to_binary_string(a)
      Enum.each(0..15, fn b ->
        bin_b = int_to_binary_string(b)
        {sum, carry} = four_bit_adder(bin_a, bin_b)
        :io.format "~2w + ~2w = ~s + ~s = ~w ~s = ~2w~n",
            [a, b, bin_a, bin_b, carry, Enum.join(sum), Integer.undigits([carry | sum], 2)]
      end)
    end)
  end
end

RC.task
