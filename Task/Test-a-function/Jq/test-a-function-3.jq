def factorial: if . <= 0 then 1 else . * ((. - 1) | factorial) end;

def palindrome: explode as $in | ($in|reverse) == $in;
