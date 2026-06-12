class Array (T)
  # assumes both are ordered
  def contains_all? (other)
    return false if other.size > size
    i = 0
    other.each do |elt|
      while i < size && self[i] < elt
        i += 1
      end
      if i < size && self[i] == elt
        i += 1
      else
        return false
      end
    end
    true
  end

  # assumes both are ordered
  def remove_elements (other)
    result = [] of T
    i = 0
    each do |elt|
      while i < other.size && other[i] < elt
        i += 1
      end
      if i < other.size && other[i] == elt
        i += 1
      else
        result << elt
      end
    end
    result
  end
end

def generate_anagram_keys (letters, anakeys)
  # pre-process the anagram keys a little
  anakeys = anakeys.select {|w| letters.contains_all? w }.group_by &.size

  # we return sequences of anagram keys which together have the same letters as
  # parameter "letters"
  result = [] of Array(Array(Char))

  # doing it recursively is probably more elegant. I'll use a stack, feel free to add
  # a recursive solution
  stack = [ { [] of Array(Char), letters } ]

  until stack.empty?
    curr_seq, curr_letters = stack.pop
    if curr_letters.empty?
      result << curr_seq
      next
    end
    ((curr_letters.size/2).ceil.to_i .. curr_letters.size).reverse_each do |length|
      if candidates = anakeys[length]?
        candidates.select {|c| curr_letters.contains_all? c }.each do |anapart|
          stack << { curr_seq + [anapart], curr_letters.remove_elements(anapart) }
        end
      end
    end
  end
  result.each do |seq| seq.sort_by! {|part| { -part.size, part } } end
  result.uniq
end

words_by_anakey = {} of Array(Char) => Array(String)

File.open("unixdict.txt") do |f|
  f.each_line do |w|
    w = w.downcase
    next unless w.size > 1 || w == "a"
    (words_by_anakey[w.chars.sort] ||= [] of String) << w
  end
end

anakeys = words_by_anakey.keys

%w(rosettacode programming chrestomathy crystal).each do |word|
  letters = word.downcase.chars.sort
  puts word + ": "
  generate_anagram_keys(letters, anakeys).each do |seq|
    puts seq.map {|part|
      "[" + words_by_anakey[part].join(" ") + "]"
    }.join(" ")
  end
  puts
end
