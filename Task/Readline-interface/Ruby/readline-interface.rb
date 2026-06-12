require "readline"
require "abbrev"

commands = %w[search download open help history quit url prev past]
Readline.completion_proc = commands.abbrev.to_proc

while buf = Readline.readline(">", true) # true means: keep history.
  exit if buf.strip == "quit"
  p buf
end
