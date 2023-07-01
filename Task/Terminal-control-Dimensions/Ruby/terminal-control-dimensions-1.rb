def winsize
  # Ruby 1.9.3 added 'io/console' to the standard library.
  require 'io/console'
  IO.console.winsize
rescue LoadError
  # This works with older Ruby, but only with systems
  # that have a tput(1) command, such as Unix clones.
  [Integer(`tput li`), Integer(`tput co`)]
end

rows, cols = winsize
printf "%d rows by %d columns\n", rows, cols
