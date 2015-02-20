require 'csv'
# read:
ar = CSV.table("test.csv").to_a #table method assumes headers and converts numbers if possible.

# manipulate:
ar.first << "SUM"
ar[1..-1].each{|row| row << row.inject(:+)}

# write:
CSV.open("out.csv", 'w') do |csv|
  ar.each{|line| csv << line}
end
