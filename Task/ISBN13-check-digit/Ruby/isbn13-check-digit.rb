def validISBN13?(str)
  cleaned = str.delete("^0-9").chars
  return false unless cleaned.size == 13
  cleaned.each_slice(2).sum{|d1, d2| d1.to_i + 3*d2.to_i }.remainder(10) == 0
end

isbns = ["978-1734314502", "978-1734314509", "978-1788399081", "978-1788399083"]
isbns.each{|isbn| puts "#{isbn}: #{validISBN13?(isbn)}" }
