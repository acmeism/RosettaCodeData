l = ""    # Sample longest string seen.
a = ""    # Accumulator to save longest strings.

STDIN.each_line do |s|
  n = "#{s}\n"
  if n[l.size]?      # Is new string longer?
    a = l = n        # Reset accumulator.
  elsif !l[n.size]?  # Same length?
    a += n           # Accumulate it.
  end
end
print a
