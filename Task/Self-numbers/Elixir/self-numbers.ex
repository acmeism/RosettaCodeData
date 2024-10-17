defmodule SelfNums do

  def digAndSum(number) when is_number(number) do
    Integer.digits(number) |>
    Enum.reduce( 0, fn(num, acc) -> num + acc end ) |>
    (fn(x) -> x + number end).()
  end

  def selfFilter(list, firstNth) do
    numRange = Enum.to_list 1..firstNth
    numRange -- list
  end

end

defmodule SelfTest do

  import SelfNums
  stop = 1000
  Enum.to_list 1..stop |>
  Enum.map(&digAndSum/1) |>
  SelfNums.selfFilter(stop) |>
  Enum.take(50) |>
  IO.inspect

end
