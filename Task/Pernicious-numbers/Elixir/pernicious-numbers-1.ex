defmodule SieveofEratosthenes do
  def init(lim) do
    find_primes(2,lim,(2..lim))
  end

  def find_primes(count,lim,nums) when (count * count) > lim do
    nums
  end

  def find_primes(count,lim,nums) when (count * count) <= lim do
    e = Enum.reject(nums,&(rem(&1,count) == 0 and &1 > count))
    find_primes(count+1,lim,e)
  end
end

defmodule PerniciousNumbers do
  def take(n) do
    primes = SieveofEratosthenes.init(100)
    Stream.iterate(1,&(&1+1))
      |> Stream.filter(&(pernicious?(&1,primes)))
      |> Enum.take(n)
      |> IO.inspect
  end

  def between(a..b) do
    primes = SieveofEratosthenes.init(100)
    a..b
      |> Stream.filter(&(pernicious?(&1,primes)))
      |> Enum.to_list
      |> IO.inspect
  end

  def ones(num) do
     num
      |> Integer.to_string(2)
      |> String.codepoints
      |> Enum.count(fn n -> n == "1" end)
  end

   def pernicious?(n,primes), do: Enum.member?(primes,ones(n))
end
