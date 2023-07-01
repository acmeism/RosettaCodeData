#!/usr/bin/ruby

bpm = Integer(ARGV[0]) rescue 60 # sets BPM by the first command line argument, set to 60 if none provided
msr = Integer(ARGV[1]) rescue 4 # sets number of beats in a measure by the second command line argument, set to 4 if none provided
i = 0

loop do
  (msr-1).times do
    puts "\a"
    sleep(60.0/bpm)
  end
  puts "\aAND #{i += 1}"
  sleep(60.0/bpm)
end
