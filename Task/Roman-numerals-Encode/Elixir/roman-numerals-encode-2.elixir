defmodule Roman_numeral do
  @symbols [ {1000, 'M'}, {900, 'CM'}, {500, 'D'}, {400, 'CD'}, {100, 'C'}, {90, 'XC'},
             {50, 'L'}, {40, 'XL'}, {10, 'X'}, {9, 'IX'}, {5, 'V'}, {4, 'IV'}, {1, 'I'} ]
  def encode(num) do
    {roman,_} = Enum.reduce(@symbols, {[], num}, fn {divisor, letter}, {memo, n} ->
                  {memo ++ List.duplicate(letter, div(n, divisor)), rem(n, divisor)}
                end)
    Enum.join(roman)
  end
end
