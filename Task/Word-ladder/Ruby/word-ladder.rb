require "set"

Words = File.open("unixdict.txt").read.split("\n").
  group_by { |w| w.length }.map { |k, v| [k, Set.new(v)] }.
  to_h

def word_ladder(from, to)
  raise "Length mismatch" unless from.length == to.length
  sized_words = Words[from.length]
  work_queue = [[from]]
  used = Set.new [from]
  while work_queue.length > 0
    new_q = []
    work_queue.each do |words|
      last_word = words[-1]
      new_tails = Enumerator.new do |enum|
        ("a".."z").each do |replacement_letter|
          last_word.length.times do |i|
            new_word = last_word.clone
            new_word[i] = replacement_letter
            next unless sized_words.include? new_word and
                        not used.include? new_word
            enum.yield new_word
            used.add new_word
            return words + [new_word] if new_word == to
          end
        end
      end
      new_tails.each do |t|
        new_q.push(words + [t])
      end
    end
    work_queue = new_q
  end
end

[%w<boy man>, %w<girl lady>, %w<john jane>, %w<child adult>].each do |from, to|
  if ladder = word_ladder(from, to)
    puts ladder.join " → "
  else
    puts "#{from} into #{to} cannot be done"
  end
end
