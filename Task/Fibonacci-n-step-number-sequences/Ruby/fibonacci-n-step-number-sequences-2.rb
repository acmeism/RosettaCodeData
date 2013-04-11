def print_nacci
  naccis = { :fibo  => [1,1],
             :lucas => [2,1],
             :tribo => [1,1,2],
             :tetra => [1,1,2,4] }

  naccis.each do |name, start_sequence|
    nacci_result = anynacci(start_sequence, 10)
    puts "#{name}nacci: #{nacci_result}"
  end

  nil
end
