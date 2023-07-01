# "clear screen":
def cls: "\u001b[2J";

# Input: an integer; 1000 ~ 1 sec
def spin:
  reduce range(1; 500 * .) as $i
    (0; . + ($i|cos)*($i|cos) + ($i|sin)*($i|sin) )
  |  "" ;

# Animate n steps;
# if "sleep" is non-negative then cls and
# sleep about "sleep" ms between frames.
def animate(n; sleep):
  if n == 0 then empty
  else (if sleep >= 0 then cls else "" end),
       (.[0]|implode), n, "\n",
       (sleep|spin),
       ( next|animate(n-1; sleep) )
  end ;

# Input: a string representing the initial state
def animation(n; sleep):
  [ explode, lines, cols] | animate(n; sleep) ;

# Input: a string representing the initial state
def frames(n):  animation(n; -1);#
