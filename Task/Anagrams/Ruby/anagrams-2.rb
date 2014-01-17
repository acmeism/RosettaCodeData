require 'open-uri'

anagrams = open('http://www.puzzlers.org/pub/wordlists/unixdict.txt'){|f| f.read.split.group_by{|w| w.each_char.sort} }
anagrams.values.group_by(&:size).max.last.each{|group| puts group.join(", ") }
