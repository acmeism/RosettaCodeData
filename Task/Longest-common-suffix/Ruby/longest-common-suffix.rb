tests = [["baabababc", "baabc", "bbbabc"],
 ["baabababc", "baabc", "bbbazc"],
 ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
 ["longest", "common", "suffix"],
 ["suffix"],
 [""],
]
def lcs(ar)
  i = (0..ar.first.size).detect{|s| ar.all?{|word| word.end_with? ar.first[s..-1]} }
  ar.first[i..-1]
end

tests.each{|test| p lcs(test) }
