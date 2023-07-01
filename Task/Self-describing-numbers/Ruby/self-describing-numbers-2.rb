def selfDesc(n)
  ns = n.to_s
  nc = ns.size
  count = Array.new(nc, 0)
  sum = 0
  while n > 0
    d = n % 10
    return false if d >= nc   # can't have a digit >= number of digits
    sum += d
    return false if sum > nc
    count[d] += 1
    n /= 10
  end
  # to be self-describing sum of digits must equal number of digits
  return false if sum != nc
  return ns == count.join() # there must always be at least one zero
end

start = Time.now
print("The self-describing numbers are:")
i  = 10  # self-describing number must end in 0
pw = 10  # power of 10
fd = 1   # first digit
sd = 1   # second digit
dg = 2   # number of digits
mx = 11  # maximum for current batch
lim = 9_100_000_001 # sum of digits can't be more than 10
while i < lim
  if selfDesc(i)
    secs = (Time.now - start) #.total_seconds
    print("\n#{i} in #{secs} secs")
  end
  i += 10
  if i > mx
    fd += 1
    sd -= 1
    if sd >= 0
      i = pw * fd
    else
      pw *= 10
      dg += 1
      i  = pw
      fd = 1
      sd = dg - 1
    end
    mx = i + sd * pw / 10
  end
end
osecs = (Time.now - start)
print("\nTook #{osecs} secs overall")
