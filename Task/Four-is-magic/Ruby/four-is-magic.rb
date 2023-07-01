module NumberToWord

  NUMBERS = {  # taken from https://en.wikipedia.org/wiki/Names_of_large_numbers#cite_ref-a_14-3
    1 => 'one',
    2 => 'two',
    3 => 'three',
    4 => 'four',
    5 => 'five',
    6 => 'six',
    7 => 'seven',
    8 => 'eight',
    9 => 'nine',
    10 => 'ten',
    11 => 'eleven',
    12 => 'twelve',
    13 => 'thirteen',
    14 => 'fourteen',
    15 => 'fifteen',
    16 => 'sixteen',
    17 => 'seventeen',
    18 => 'eighteen',
    19 => 'nineteen',
    20 => 'twenty',
    30 => 'thirty',
    40 => 'forty',
    50 => 'fifty',
    60 => 'sixty',
    70 => 'seventy',
    80 => 'eighty',
    90 => 'ninety',
    100 => 'hundred',
    1000 => 'thousand',
    10 ** 6 => 'million',
    10 ** 9 => 'billion',
    10 ** 12 => 'trillion',
    10 ** 15 => 'quadrillion',
    10 ** 18 => 'quintillion',
    10 ** 21 => 'sextillion',
    10 ** 24 => 'septillion',
    10 ** 27 => 'octillion',
    10 ** 30 => 'nonillion',
    10 ** 33 => 'decillion'}.reverse_each.to_h

  refine Integer do
    def to_english
      return 'zero' if i.zero?
      words =  self < 0 ? ['negative'] : []
      i = self.abs
      NUMBERS.each do |k, v|
        if k <= i then
          times = i/k
          words << times.to_english if k >= 100
          words << v
          i -= times * k
        end
        return words.join(" ") if i.zero?
      end
    end
  end

end

using  NumberToWord

def magic4(n)
  words = []
  until n == 4
    s = n.to_english
    n = s.size
    words << "#{s} is #{n.to_english}"
  end
  words << "four is magic."
  words.join(", ").capitalize
end

[0, 4, 6, 11, 13, 75, 337, -164, 9_876_543_209].each{|n| puts magic4(n) }
