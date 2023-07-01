# Build environments
envs = (1..12).map do |n|
  Object.new.instance_eval {@n = n; @cnt = 0; self}
end

# Until all values are 1:
until envs.all? {|e| e.instance_eval{@n} == 1}
  envs.each do |e|
    e.instance_eval do          # Use environment _e_
      printf "%4s", @n
      if @n > 1
        @cnt += 1               # Increment step count
        @n = if @n.odd?         # Calculate next hailstone value
               @n * 3 + 1
             else
               @n / 2
             end
      end
    end
  end
  puts
end
puts '=' * 48
envs.each do |e|                # For each environment _e_
  e.instance_eval do
    printf "%4s", @cnt          # print the step count
  end
end
puts
