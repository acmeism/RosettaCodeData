def task($n):
  [colorfuls(0; $n)]
  | "The \(length) colorful numbers less than \($n) are:",
    (_nwise($10) | map(lpad(4)) | join(" ")) ;

def largestColorful:
  [[range(2;10)] | permutations | join("") | tonumber | select(isColorful)] | max;

# Emit a JSON object giving the counts by number of digits
def classifyColorful:
  def nonTrivialCandidates:
    [range(2; 10)]
    | range(1; 9) as $length
    | combinations($length)
    | join("")
    | tonumber;
  reduce (0,1,nonTrivialCandidates) as $i ({};
     if $i|isColorful
     then .[$i|tostring|length|tostring] += 1
     else .
     end);

task(100),
"",
"The largest possible colorful number is \(largestColorful)."
"",
"The counts of colorful numbers by number of digits are:",
(classifyColorful
 | (., "\nTotal: \([.[]]|add)"))
