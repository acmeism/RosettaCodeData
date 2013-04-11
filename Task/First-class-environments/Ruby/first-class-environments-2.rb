# Build environments
envs = (1..12).map do |n|
  e = class Object
        # This is a new lexical scope with no local variables.
        # Create a new binding here.
        binding
      end
  eval(<<-'eos', e).call(n)
    n, cnt = nil, 0
    proc {|arg| n = arg}
  eos
  next e
end

# Until all values are 1:
while envs.find {|e| eval('n > 1', e)}
  envs.each do |e|
    eval(<<-'eos', e)           # Use environment _e_
      printf "%4s", n
      unless 1 == n
        cnt += 1                # Increment step count
        n = if 1 & n == 1       # Calculate next hailstone value
              n * 3 + 1
            else
              n / 2
            end
      end
    eos
  end
  puts
end
puts '=' * 48
envs.each do |e|                # For each environment _e_
  eval(<<-'eos', e)
    printf "%4s", cnt           # print the step count
  eos
end
puts
