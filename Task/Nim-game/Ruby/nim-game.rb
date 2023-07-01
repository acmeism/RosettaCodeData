[12, 8, 4].each do |remaining|
  puts "There are #{remaining} dots.\nHow many dots would you like to take? "
  unless (num=gets.to_i).between?(1, 3)
    puts "Please enter one of 1, 2 or 3"
    redo
  end
  puts "You took #{num} dots, leaving #{remaining-num}.\nComputer takes #{4-num}.\n\n"
end

puts "Computer took the last and wins."
