# Pseudosleep for at least the given number of seconds,
# and emit the actual number of seconds that have elapsed.
def sleep($seconds):
  now
  | . as $now
  | until( .  - $now >= $seconds; now)
  | . - $now ;

def esc: "\u001b";

def colors: ["Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White"];

# display words using 'bright' colors
(range(1; 1 + (colors|length)) | "\(esc)[\(30+.);1m\(colors[.])"), # red to white
sleep(3),        # wait for 3 seconds
"\(esc)[47m",    # set background color to white
"\(esc)[2J",     # clear screen to background color
"\(esc)[H",      # home the cursor

# display words again using 'blinking' colors
"\(esc)[5m",     # blink on
(range(0;6) | "\(esc)[\(30+.);1m\(colors[.])"), # black to cyan
sleep(3),        # wait for 3 more seconds
"\(esc)[0m",     # reset all attributes
"\(esc)[2J",     # clear screen to background color
"\(esc)[H"       # home the cursor
