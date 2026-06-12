require 'number_names'

def int_from_words(num)
  words = num.downcase.gsub(/(,| and |-)/,' ').split
  if words[0] =~ /(minus|negative)/
    negmult = -1
    words.shift
  else
    negmult = 1
  end
  small, total = 0, 0
  for word in words
    case word
    when *SMALL
      small += SMALL.index(word)
    when *TENS
      small += TENS.index(word) * 10
    when 'hundred'
      small *= 100
    when 'thousand'
      total += small * 1000
      small = 0
    when *BIG
      total += small * 1000 ** BIG.index(word)
      small = 0
    else
      raise ArgumentError, "Don't understand %s part of %s" % [word, num]
    end
  end
  negmult * (total + small)
end
