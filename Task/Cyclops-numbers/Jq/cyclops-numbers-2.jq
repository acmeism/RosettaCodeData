def print5x10($width):
  . as $a
  | range(0;5) as $i
  | reduce range(0;10) as $j (""; . + ($a[10*$i + $j] | lpad($width)));

def main_task($n):
    "The first \($n) cyclops numbers are:",
     ([limit($n; cyclops)] | print5x10(7)),

    "\nThe first \($n) prime cyclops numbers are:",
     ([limit($n; cyclops | select(is_prime))] | print5x10(7)),

    "\nThe first \($n) blind prime cyclops numbers are:",
     ([limit($n; cyclops | select(is_prime and cyclops_isblind))] | print5x10(7)),

    "\nThe first \($n) palindromic prime cyclops numbers are:",
     ([limit($n; cyclops | select(cyclops_ispalindromic and is_prime))] | print5x10(8)) ;

def stretch_task($big):
   def pp: " \(.[1]) at index \(.[0]).";
    "\nFirst cyclops greater than \($big):" +
     (first(enumerate(cyclops) | select(.[1] > $big))|pp),

   "\nThe next prime cyclops number after \($big):" +
     (first(enumerate(cyclops | select(is_prime)) | select(.[1] | (. > $big)) ) | pp),

    "\nThe first blind prime cyclops number greater than \($big):" +
     (first(enumerate(cyclops | select(is_prime and cyclops_isblind)) | select(.[1] > $big) )|pp),

    "\nThe first palindromic prime cyclops number greater than \($big):" +
     (first(enumerate(palindromiccyclops | select(is_prime)) | select(.[1] > $big) ) | pp) ;

main_task(50),
stretch_task(pow(10;7))
