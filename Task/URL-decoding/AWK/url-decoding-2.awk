LC_ALL=C
  echo "http%3A%2F%2Ffoo%20bar%2F" | gawk -vRS='%[[:xdigit:]]{2}' '
  RT {RT = sprintf("%c",strtonum("0x" substr(RT, 2)))}
  {gsub(/+/," ");printf "%s", $0 RT}'
