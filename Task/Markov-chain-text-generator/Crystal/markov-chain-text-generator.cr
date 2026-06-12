class Markov(N)
  @dictionary = Hash(StaticArray(String, N), Array(String)).new { [] of String }

  def parse(filename : String)
    File.open(filename) do |file|
      parse(file)
    end
  end

  private def prefix_from(array)
    StaticArray(String, N).new { |i| array[-(N - i)] }
  end

  def parse(input : IO)
    sequence = [] of String
    loop do
      word = input.gets(' ', true)
      break unless word
      if sequence.size == N
        prefix = prefix_from(sequence)
        @dictionary[prefix] = (@dictionary[prefix] << word)
      end
      sequence << word
      sequence.shift if sequence.size > N
    end
  end

  def generate(count)
    prefix = @dictionary.keys.sample
    result = Array(String).new(prefix.size) { |i| prefix[i] }
    (count - N).times do
      prefix = prefix_from(result)
      values = @dictionary[prefix]
      break if values.size == 0
      result << values.sample
    end
    result.join(' ')
  end
end

chain = Markov(3).new
chain.parse("alice_oz.txt")
puts chain.generate(200)
