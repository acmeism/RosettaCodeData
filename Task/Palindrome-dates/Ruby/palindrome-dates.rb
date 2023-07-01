require 'date'

palindate = Enumerator.new do |yielder|
  ("2020"..).each do |y|
    m, d = y.reverse.scan(/../) # let the Y10K kids handle 5 digit years
    strings = [y, m, d]
    yielder << strings.join("-") if Date.valid_date?( *strings.map( &:to_i ) )
  end
end

puts palindate.take(15)
