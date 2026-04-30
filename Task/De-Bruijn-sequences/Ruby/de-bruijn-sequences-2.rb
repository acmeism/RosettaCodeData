def de_bruijn(k, n)
  # de Bruijn sequence for alphabet k and subsequences of length n
  alphabet = if k.is_a?(Integer)
               (0...k).map(&:to_s)
             else
               k.chars
             end
  k = alphabet.size
  a = Array.new(k * n, 0)
  sequence = []

  def db(t, p, a, k, n, sequence)
    if t > n
      sequence.concat(a[1..p]) if n % p == 0
    else
      a[t] = a[t - p]
      db(t + 1, p, a, k, n, sequence)
      (a[t - p] + 1...k).each do |j|
        a[t] = j
        db(t + 1, t, a, k, n, sequence)
      end
    end
  end

  db(1, 1, a, k, n, sequence)
  sequence.map { |i| alphabet[i] }.join
end

def validate(db)
  dbwithwrap = db + db[0, 3]
  digits = '0123456789'
  errorstrings = []

  digits.chars.each do |d1|
    digits.chars.each do |d2|
      digits.chars.each do |d3|
        digits.chars.each do |d4|
          teststring = d1 + d2 + d3 + d4
          errorstrings << teststring unless dbwithwrap.include?(teststring)
        end
      end
    end
  end

  if errorstrings.any?
    puts "  #{errorstrings.size} errors found:"
    errorstrings.each { |e| puts "  PIN number #{e} missing" }
  else
    puts "  No errors found"
  end
end

db = de_bruijn(10, 4)
puts ""
puts "The length of the de Bruijn sequence is #{db.length}"
puts ""
puts "The first 130 digits of the de Bruijn sequence are: #{db[0, 130]}"
puts ""
puts "The last 130 digits of the de Bruijn sequence are: #{db[-130..-1]}"
puts ""
puts "Validating the deBruijn sequence:"
validate(db)

dbreversed = db.reverse
puts ""
puts "Validating the reversed deBruijn sequence:"
validate(dbreversed)

dboverlaid = db[0, 4443] + '.' + db[4444..-1]
puts ""
puts "Validating the overlaid deBruijn sequence:"
validate(dboverlaid)
