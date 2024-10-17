require "http/client"

response = HTTP::Client.get("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")

if response.body?
  words : Array(String) = response.body.split

  anagram = {} of String => Array(String)

  words.each do |word|
    key = word.split("").sort.join

    if !anagram[key]?
      anagram[key] = [word]
    else
      anagram[key] << word
    end
  end

  count = anagram.values.map { |ana| ana.size }.max
  anagram.each_value { |ana| puts ana if ana.size >= count }
end
