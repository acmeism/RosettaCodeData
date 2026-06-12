def order (filename)
  File.read_lines(filename).sort_by {|line|
    line.split[-2].to_i * (line.ends_with?("BCE") ? -1 : 1)
  }
end

puts order("table.txt").join("\n")
puts
puts order("table2.txt").join("\n")
puts
puts order("table3.txt").join("\n")
