defmodule Complex do
  import Kernel, except: [abs: 1, div: 2]

  defstruct real: 0, imag: 0

  def new(real, imag) do
    %__MODULE__{real: real, imag: imag}
  end

  def add(a, b) do
    {a, b} = convert(a, b)
    new(a.real + b.real, a.imag + b.imag)
  end

  def sub(a, b) do
    {a, b} = convert(a, b)
    new(a.real - b.real, a.imag - b.imag)
  end

  def mul(a, b) do
    {a, b} = convert(a, b)
    new(a.real*b.real - a.imag*b.imag, a.imag*b.real + a.real*b.imag)
  end

  def div(a, b) do
    {a, b} = convert(a, b)
    divisor = abs2(b)
    new((a.real*b.real + a.imag*b.imag) / divisor,
        (a.imag*b.real - a.real*b.imag) / divisor)
  end

  def neg(a) do
    a = convert(a)
    new(-a.real, -a.imag)
  end

  def inv(a) do
    a = convert(a)
    divisor = abs2(a)
    new(a.real / divisor, -a.imag / divisor)
  end

  def conj(a) do
    a = convert(a)
    new(a.real, -a.imag)
  end

  def abs(a) do
    :math.sqrt(abs2(a))
  end

  defp abs2(a) do
    a = convert(a)
    a.real*a.real + a.imag*a.imag
  end

  defp convert(a) when is_number(a), do: new(a, 0)
  defp convert(%__MODULE__{} = a), do: a

  defp convert(a, b), do: {convert(a), convert(b)}

  def task do
    a = new(1, 3)
    b = new(5, 2)
    IO.puts "a = #{a}"
    IO.puts "b = #{b}"
    IO.puts "add(a,b): #{add(a, b)}"
    IO.puts "sub(a,b): #{sub(a, b)}"
    IO.puts "mul(a,b): #{mul(a, b)}"
    IO.puts "div(a,b): #{div(a, b)}"
    IO.puts "div(b,a): #{div(b, a)}"
    IO.puts "neg(a)  : #{neg(a)}"
    IO.puts "inv(a)  : #{inv(a)}"
    IO.puts "conj(a) : #{conj(a)}"
  end
end

defimpl String.Chars, for: Complex do
  def to_string(%Complex{real: real, imag: imag}) do
    if imag >= 0, do: "#{real}+#{imag}j",
                else: "#{real}#{imag}j"
  end
end

Complex.task
