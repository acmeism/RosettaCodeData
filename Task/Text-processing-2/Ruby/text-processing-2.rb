require 'set'

def munge2(readings, debug=false)
   datePat = /^\d{4}-\d{2}-\d{2}/
   valuPat = /^[-+]?\d+\.\d+/
   statPat = /^-?\d+/
   totalLines = 0
   dupdate, badform, badlen, badreading = Set[], Set[], Set[], 0
   datestamps = Set[[]]
   for line in readings
      totalLines += 1
      fields = line.split(/\t/)
      date = fields.shift
      pairs = fields.enum_slice(2).to_a

      lineFormatOk = date =~ datePat &&
        pairs.all? { |x,y| x =~ valuPat && y =~ statPat }
      if !lineFormatOk
         puts 'Bad formatting ' + line if debug
         badform << date
      end

      if pairs.length != 24 ||
           pairs.any? { |x,y| y.to_i < 1 }
         puts 'Missing values ' + line if debug
      end
      if pairs.length != 24
         badlen << date
      end
      if pairs.any? { |x,y| y.to_i < 1 }
         badreading += 1
      end

      if datestamps.include?(date)
         puts 'Duplicate datestamp ' + line if debug
         dupdate << date
      end

      datestamps << date
   end

   puts 'Duplicate dates:', dupdate.sort.map { |x| '  ' + x }
   puts 'Bad format:', badform.sort.map { |x| '  ' + x }
   puts 'Bad number of fields:', badlen.sort.map { |x| '  ' + x }
   puts 'Records with good readings: %i = %5.2f%%' % [
      totalLines-badreading, (totalLines-badreading)/totalLines.to_f*100 ]
   puts
   puts 'Total records:  %d' % totalLines
end

open('readings.txt','r') do |readings|
   munge2(readings)
end
