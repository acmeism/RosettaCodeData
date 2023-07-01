require "http/client"
require "regex"

# Get the text from the internet
response = HTTP::Client.get "https://www.gutenberg.org/files/135/135-0.txt"
text = response.body

text
  .downcase
  .scan(/[a-zA-ZáéíóúÁÉÍÓÚâêôäüöàèìòùñ']+/)
  .reduce({} of String => Int32) { |hash, match|
    word = match[0]
    hash[word] = hash.fetch(word, 0) + 1 # using fetch to set a default value (1) to the new found word
    hash
  }
  .to_a                                        # convert the returned hash to an array of tuples (String, Int32) -> {word, sum}
  .sort { |a, b| b[1] <=> a[1] }[0..9]         # sort and get the first 10 elements
  .each_with_index(1) { |(word, n), i| puts "#{i} \t #{word} \t #{n}" } # print the result
