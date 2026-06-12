# Output: a stream
def simple:
  range(2; 7) as $n
  | [2, 3, 5, 7]
  | combinations($n)
  | select(add == 13)
  | join("") | tonumber;

count(simple)
