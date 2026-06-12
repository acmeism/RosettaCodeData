def ngrams (s, n)
  counter = Hash(String, Int32).new(0)
  s.chars.each_cons(n) do |arr|
    counter[arr.join("")] += 1
  end
  counter
end

string = "live and let live"
(2..4).each do |i|
  pp i, ngrams(string, i)
end
