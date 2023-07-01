# Be busy for at least the given number of seconds,
# and emit the actual number of seconds that have elapsed.
# The reason for defining sleep/1 is that it allows the idiom:
#  E | F, (sleep(1) as $elapsed | CONTINUE_WITH_E_AS_INPUT)
def sleep($seconds):
  now
  | . as $now
  | until( .  - $now >= $seconds; now)
  | . - $now ;

def demo:
  def ESC: "\u001B";
  def s: sleep(2) | empty;

  "\(ESC)[2J",     # clear terminal
  "\(ESC)[12;40H", # move to (12, 40)
  s,
  "\(ESC)[D",      # move left
  s,
  "\(ESC)[C",      # move right
  s,
  "\(ESC)[A",      # move up
  s,
  "\(ESC)[B",      # move down
  s,
  "\(ESC)[G",      # move to beginning of line
  s,
  "\(ESC)[79C",    # move to end of line (assuming 80 column terminal)
  s,
  "\(ESC)[1;1H",   # move to top left corner
  s,
  "\(ESC)[24;80H", # move to bottom right corner (assuming 80 x 24 terminal)
  s,
  "\(ESC)[1;1H"   # home cursor again before quitting
;

demo
