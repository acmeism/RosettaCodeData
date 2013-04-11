def eratosthenes2(n)
  # For odd i, if i is prime, nums[i >> 1] is true.
  # Set false for all multiples of 3.
  nums = [true, false, true] * ((n + 5) / 6)
  nums[0] = false  # 1 is not prime.
  nums[1] = true   # 3 is prime.

  # Outer loop and both inner loops are skipping multiples of 2 and 3.
  # Outer loop checks i * i > n, same as i > Math.sqrt(n).
  i = 5
  until(m = i * i
        m > n) do
    if nums[i >> 1]
      i_times_2 = i << 1
      i_times_4 = i << 2
      while m <= n
        nums[m >> 1] = false
        m += i_times_2
        nums[m >> 1] = false
        m += i_times_4  # When i = 5, skip 45, 75, 105, ...
      end
    end
    i += 2
    if nums[i >> 1]
      m = i * i
      i_times_2 = i << 1
      i_times_4 = i << 2
      while m <= n
        nums[m >> 1] = false
        m += i_times_4  # When i = 7, skip 63, 105, 147, ...
        nums[m >> 1] = false
        m += i_times_2
      end
    end
    i += 4
  end

  primes = [2]
  nums.each_index {|i| primes << (i * 2 + 1) if nums[i]}
  primes.pop while primes.last > n
  return primes
end

p eratosthenes2(100)
