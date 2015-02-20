SMALL = %w(zero one two three four five six seven eight nine ten
           eleven twelve thirteen fourteen fifteen sixteen seventeen
           eighteen nineteen)

TENS = %w(wrong wrong twenty thirty forty fifty sixty seventy
          eighty ninety)

BIG = [nil, "thousand"] +
      %w( m b tr quadr quint sext sept oct non dec).map{ |p| "#{p}illion" }

def wordify number
  case
  when number < 0
    "negative #{wordify -number}"

  when number < 20
    SMALL[number]

  when number < 100
    div, mod = number.divmod(10)
    TENS[div] + (mod==0 ? "" : "-#{wordify mod}")

  when number < 1000
    div, mod = number.divmod(100)
    "#{SMALL[div]} hundred" + (mod==0 ? "" : " and #{wordify mod}")

  else
    # separate into 3-digit chunks
    chunks = []
    div = number
    while div != 0
      div, mod = div.divmod(1000)
      chunks << mod                 # will store smallest to largest
    end

    raise ArgumentError, "Integer value too large." if chunks.size > BIG.size

    chunks.map{ |c| wordify c }.
           zip(BIG).    # zip pairs up corresponding elements from the two arrays
           find_all { |c| c[0] != 'zero' }.
           map{ |c| c.join ' '}.    # join ["forty", "thousand"]
           reverse.
           join(', ').              # join chunks
           strip
  end
end

data = [-1123, 0, 1, 20, 123, 200, 220, 1245, 2000, 2200, 2220, 467889,
        23_000_467, 23_234_467, 2_235_654_234, 12_123_234_543_543_456,
        987_654_321_098_765_432_109_876_543_210_987_654,
        123890812938219038290489327894327894723897432]

data.each do |n|
  print "#{n}: "
  begin
    puts "'#{wordify n}'"
  rescue => e
    puts "Error: #{e}"
  end
end
