puts "Enter a number of seconds:"
seconds = gets.chomp.to_i
puts "Enter a MP3 file to be played"
mp3filepath = File.dirname(__FILE__) + "/" + gets.chomp + ".mp3"
sleep(seconds)
pid = fork{ exec 'mpg123','-q', mp3filepath }
