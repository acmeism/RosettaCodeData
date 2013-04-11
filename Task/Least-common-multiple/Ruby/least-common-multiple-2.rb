def lcm(*args)
  args.inject(1) do |m, n|
    next 0 if m == 0 or n == 0
    i = m
    loop do
      break i if i % n == 0
      i += m
    end
  end
end
