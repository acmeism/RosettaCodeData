defmodule Bitwise_operation do
  use Bitwise

  def test(a \\ 255, b \\ 170, c \\ 2) do
    IO.puts "Bitwise function:"
    IO.puts "band(#{a}, #{b}) = #{band(a, b)}"
    IO.puts "bor(#{a}, #{b}) = #{bor(a, b)}"
    IO.puts "bxor(#{a}, #{b}) = #{bxor(a, b)}"
    IO.puts "bnot(#{a}) = #{bnot(a)}"
    IO.puts "bsl(#{a}, #{c}) = #{bsl(a, c)}"
    IO.puts "bsr(#{a}, #{c}) = #{bsr(a, c)}"
    IO.puts "\nBitwise as operator:"
    IO.puts "#{a} &&& #{b} = #{a &&& b}"
    IO.puts "#{a} ||| #{b} = #{a ||| b}"
    IO.puts "#{a} ^^^ #{b} = #{a ^^^ b}"
    IO.puts "~~~#{a} = #{~~~a}"
    IO.puts "#{a} <<< #{c} = #{a <<< c}"
    IO.puts "#{a} >>> #{c} = #{a >>> c}"
  end
end

Bitwise_operation.test
