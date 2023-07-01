def pause($seconds):
  (now + $seconds)
  | until( now > . ; .);

# Specify $n as null for an infinite spin
def animation($n):
  def ESC: "\u001b";
  def hide: "\(ESC)[?25l";    # hide the cursor
  def restore: "\(ESC)[?25h"; # restore the cursor;
  def a: "🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘";

  hide,
  "\(ESC)[2J\(ESC)[H",        # clear, place cursor at top left corner
  (range(0; $n // infinite) as $_
   | a as $a
   | pause(0.05)
   | "\r\($a)" ),
  restore;

animation(10)
