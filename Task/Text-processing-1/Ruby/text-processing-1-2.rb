Reading = Struct.new(:date, :value, :flag)

DailyReading = Struct.new(:date, :readings) do
  def good() readings.select(&:flag) end
  def bad() readings.reject(&:flag) end
  def sum() good.map(&:value).inject(0.0) {|sum, val| sum + val } end
  def avg() good.size > 0 ? (sum / good.size) : 0 end
  def print_status
    puts "%11s:  good: %2d  bad: %2d  total: %8.3f  avg: %6.3f" % [date, good.count, bad.count, sum, avg]
    self
  end
end

daily_readings = IO.foreach(ARGV.first).map do |line|
  (date, *parts) = line.chomp.split(/\s/)
  readings = parts.each_slice(2).map {|pair| Reading.new(date, pair.first.to_f, pair.last.to_i > 0)}
  DailyReading.new(date, readings).print_status
end

all_readings = daily_readings.flat_map(&:readings)
good_readings = all_readings.select(&:flag)
all_streaks = all_readings.slice_when {|bef, aft| bef.flag != aft.flag }
worst_streak = all_streaks.reject {|grp| grp.any?(&:flag)}.sort_by(&:size).last

total = good_readings.map(&:value).reduce(:+)
num_readings = good_readings.count
puts
puts "Total: %.3f" % total
puts "Readings: #{num_readings}"
puts "Average  %.3f" % total./(num_readings)
puts
puts "Max run of #{worst_streak.count} consecutive false readings from #{worst_streak.first.date} until #{worst_streak.last.date}"
