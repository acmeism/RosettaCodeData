defmodule Self_describing do
  def number(n) do
    digits = Integer.digits(n)
    Enum.map(0..length(digits)-1, fn s ->
      length(Enum.filter(digits, fn c -> c==s end))
    end) == digits
  end
end

m = 3300000
Enum.filter(0..m, fn n -> Self_describing.number(n) end)
