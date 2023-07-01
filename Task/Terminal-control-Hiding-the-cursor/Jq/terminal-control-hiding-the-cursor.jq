# Be busy for at least the given number of seconds,
# and emit the actual number of seconds that have elapsed.
def sleep($seconds):
  now
  | . as $now
  | until( .  - $now >= $seconds; now)
  | . - $now ;

def demo:
  def ESC: "\u001B";
  def reset: "\(ESC)[0H\(ESC)[0J\(ESC)[?25h";

  reset,
  "Now you see it ...",
  (sleep(2) | empty),
  "\(ESC)[?25l",                       # hide the cursor
  "... now you don't.",
  "Press RETURN to reset the screen and cursor.",
  (first(inputs) | empty),
  reset;

demo
