# run_encode("aaabbbbc") #=> [["a", 3], ["b", 4], ["c", 1]]
def run_encode(string)
  string
    .chars
    .chunk{|i| i}
    .map {|kind, array| [kind, array.length]}
end

# run_decode([["a", 3], ["b", 4], ["c", 1]]) #=> "aaabbbbc"
def run_decode(char_counts)
  char_counts
    .map{|char, count| char * count}
    .join
end
