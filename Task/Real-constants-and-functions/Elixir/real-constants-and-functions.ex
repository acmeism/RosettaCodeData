defmodule Real_constants_and_functions do
  def main do
    IO.puts :math.exp(1)                # e
    IO.puts :math.pi                    # pi
    IO.puts :math.sqrt(16)              # square root
    IO.puts :math.log(10)               # natural logarithm
    IO.puts :math.log10(10)             # base 10 logarithm
    IO.puts :math.exp(2)                # e raised to the power of x
    IO.puts abs(-2.24)                  # absolute value
    IO.puts Float.floor(3.1423)         # floor
    IO.puts Float.ceil(20.125)          # ceiling
    IO.puts :math.pow(3,2)              # exponentiation
  end
end

Real_constants_and_functions.main
