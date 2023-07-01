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
  "\(ESC)[7mInverse",
  (sleep(2) | "\(ESC)[0mNormal");

demo
