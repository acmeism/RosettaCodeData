# If your jq has "while", then feel free to omit the following definition:
def while(cond; update):
  def _while:  if cond then ., (update | _while) else empty end;
  _while;

# The first k narcissistic numbers, beginning with 0:
def narcissistic(k):
  # State: [n, is_narcissistic, count, [len, [0^len, 1^len, ...]]]
  # where len is the number of digits in n.
  [0, true, 1, [1, [range(0;10)]]]
  | while( .[2] <= k;
           .[3] as $powers
           | (.[0]+1) as $n
           | ($n | tostring | length) as $len
	   | ($powers | powers($len)) as $powersprime
	   | if [$n, $powersprime] | is_narcissistic
	     then [$n, true, .[2] + 1, $powersprime]
	     else [$n, false, .[2], $powersprime ]
	     end )
  | select(.[1])
  | "\(.[2]): \(.[0])" ;

narcissistic(25)
