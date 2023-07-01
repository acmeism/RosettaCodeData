str = "rosetta code phrase reversal"

puts str.reverse                          # Reversed string.
puts str.split.map(&:reverse).join(" ")   # Words reversed.
puts str.split.reverse.join(" ")          # Word order reversed.
