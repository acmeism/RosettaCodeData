def c n, r
  (0...r).inject(1) do |m,i| (m * (n - i)) / (i + 1) end
end
