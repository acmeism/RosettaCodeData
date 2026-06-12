def round_robin( n )
  rotating_players = (2..n).map(&:to_s) #player 1 to be added later
  rotating_players << "bye" if n.odd?
  Array.new(rotating_players.size) do |r|
    all = ["1"] + rotating_players.rotate(-r)
    [all[0, all.size/2], all[all.size/2..].reverse]
  end
end

round_robin(12).each.with_index(1) do |round, i|
  puts "Round #{i}"
  round.each do |players|
    puts players.map{|player| player.ljust(4)}.join
  end
  puts
end
