def spinning_rod
  begin
    printf("\033[?25l") # Hide cursor
    '🌑🌒🌓🌔🌕🌖🌗🌘'.chars.cycle do |rod|
      print rod
      sleep 0.25
      print "\r"
    end
  ensure
    printf("\033[?25h") # Restore cursor
  end
end

puts "Ctrl-c to stop."
spinning_rod
