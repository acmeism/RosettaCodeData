# Build environments
envs = (1..12).map do |n|
  e = class Object
        # This is a new lexical scope with no local variables.
        # Create a new binding here.
        binding
      end
  eval(<<-EOS, e).call(n)
    n, cnt = nil, 0
    proc {|arg| n = arg}
  EOS
  e
end

# Until all values are 1:
until envs.all? {|e| eval('n == 1', e)}
  envs.each do |e|
    eval(<<-EOS, e)           # Use environment _e_
      printf "%4s", n
      if n > 1
        cnt += 1              # Increment step count
        n = if n.odd?         # Calculate next hailstone value
              n * 3 + 1
            else
              n / 2
            end
      end
    EOS
  end
  puts
end
puts '=' * 48
envs.each do |e|                # For each environment _e_
  eval('printf "%4s", cnt', e)  # print the step count
end
puts
