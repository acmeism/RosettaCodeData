defmodule SieveofEratosthenes do
  def init(lim) do
    find_primes(2,lim,(2..lim))
  end

  def find_primes(count,lim,nums) when (count * count) > lim do
    nums
  end

  def find_primes(count,lim,nums) when (count * count) <= lim do
    find_primes(count+1,lim,Enum.reject(nums,&(rem(&1,count) == 0 and &1 > count)))
  end
end
