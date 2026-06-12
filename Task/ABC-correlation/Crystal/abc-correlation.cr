def abc_correlates? (string)
  string.count('a') == string.count('b') == string.count('c')
end

print "Enter a string: "; STDOUT.flush
word = gets || exit
puts "#{word} does#{abc_correlates?(word) ? "" : "n't"} ABC-correlate."
