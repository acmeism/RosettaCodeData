tokens = 12

until tokens <= 0
    puts "There are #{tokens} tokens remaining.\nHow many tokens do you take?"
    until (input = (gets || "").to_i?) && (1..3).includes? input
        puts "Enter an integer between 1 and 3."
    end
    puts "Player takes #{input} tokens.\nComputer takes #{4-input} tokens."
    tokens -= 4
end

puts "Computer wins."
