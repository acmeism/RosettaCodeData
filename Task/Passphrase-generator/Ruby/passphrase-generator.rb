require "securerandom"

PRNG = SecureRandom

WORDS = File.foreach("unixdict.txt", chomp: true)
            .lazy
            .filter_map { |word| word.capitalize if word.size.between?(4, 9) }
            .to_a

def passphrase(n)
  raise "n must be between 3 and 7" unless n.between?(3, 7)
  n.times.map { "#{WORDS[PRNG.rand(WORDS.size)]}#{PRNG.rand(10..100)}" }.join("-")
end

5.times { puts passphrase(5) } if __FILE__ == $PROGRAM_NAME
