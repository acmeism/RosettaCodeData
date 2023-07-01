class PigGame
  Player = Struct.new(:name, :safescore, :score) do
    def bust!() self.score = safescore end
    def stay!() self.safescore = score end
    def to_s() "#{name} (#{safescore}, #{score})" end
  end

  def initialize(names, maxscore=100, die_sides=6)
    rotation = names.map {|name| Player.new(name,0,0) }

    rotation.cycle do |player|
      loop do
        if wants_to_roll?(player)
          puts "Rolled: #{roll=roll_dice(die_sides)}"
          if bust?(roll)
            puts "Busted!",''
            player.bust!
            break
          else
            player.score += roll
            if player.score >= maxscore
              puts player.name + " wins!"
              return
            end
          end
        else
          player.stay!
          puts "Staying with #{player.safescore}!", ''
          break
        end
      end
    end
  end

  def roll_dice(die_sides) rand(1..die_sides) end
  def bust?(roll) roll==1 end
  def wants_to_roll?(player)
    print "#{player}: Roll? (Y) "
    ['Y','y',''].include?(gets.chomp)
  end
end

PigGame.new( %w|Samuel Elizabeth| )
