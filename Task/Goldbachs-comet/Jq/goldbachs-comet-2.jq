# emit nothing if . is odd
def G:
  select(. % 2 == 0)
  | count( range(2; (./2)+1) as $i
           | select(($i|is_prime) and ((.-$i)|is_prime)) );

def task1:
  "The first 100 G numbers:",
  ([range(4; 203; 2) | G] | nwise(10) | map(lpad(4)) | join(" "));

def task($n):
  $n, 4, 22
  |"G(\(.)): \(G)";

task1, "", task(1000000)
