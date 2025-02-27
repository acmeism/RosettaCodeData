TARGET = "METHINKS IT IS LIKE A WEASEL".chars
ALPHABET = ('A'..'Z').to_a << ' '
C = 200
RATE = 0.05

def fitness (current, target)
  current.zip(target).count {|a, b| a == b } / current.size
end

def mutate (current, rate)
  current.map {|ch| Random.rand < rate ? ALPHABET.sample : ch }
end

def next_parent (current, target, c, rate)
  candidate = current
  candidate_fitness = fitness(current, target)
  c.times do
    child = mutate(current, rate)
    child_fitness = fitness(child, target)
    if child_fitness > candidate_fitness
      candidate, candidate_fitness = child, child_fitness
    end
  end
  candidate
end

parent = TARGET.map { ALPHABET.sample }

(1..).each do |gen|
  printf "%4d  %s\n", gen, parent.join
  break if parent == TARGET
  parent = next_parent(parent, TARGET, C, RATE)
end
