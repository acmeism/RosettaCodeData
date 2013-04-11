filename = "readings.txt"
total = { "num_readings" => 0, "num_good_readings" => 0, "sum_readings" => 0.0 }
invalid_count = 0
max_invalid_count = 0
invalid_run_end = ""

File.new(filename).each do |line|
  num_readings = 0
  num_good_readings = 0
  sum_readings = 0.0

  fields = line.split
  fields[1..-1].each_slice(2) do |reading, flag|
    num_readings += 1
    if Integer(flag) > 0
      num_good_readings += 1
      sum_readings += Float(reading)
      invalid_count = 0
    else
      invalid_count += 1
      if invalid_count > max_invalid_count
        max_invalid_count = invalid_count
        invalid_run_end = fields[0]
      end
    end
  end

  printf "Line: %11s  Reject: %2d  Accept: %2d  Line_tot: %10.3f  Line_avg: %10.3f\n",
    fields[0], num_readings - num_good_readings, num_good_readings, sum_readings,
    num_good_readings > 0 ? sum_readings/num_good_readings : 0.0

  total["num_readings"] += num_readings
  total["num_good_readings"] += num_good_readings
  total["sum_readings"] += sum_readings
end

puts ""
puts "File(s)  = #{filename}"
printf "Total    = %.3f\n", total['sum_readings']
puts "Readings = #{total['num_good_readings']}"
printf "Average  = %.3f\n", total['sum_readings']/total['num_good_readings']
puts ""
puts "Maximum run(s) of #{max_invalid_count} consecutive false readings ends at #{invalid_run_end}"
