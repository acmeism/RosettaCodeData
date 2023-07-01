recurse()
{
  # since the example runs slowly, the following
  # if-elif avoid unuseful output; the elif was
  # added after a first run ended with a segmentation
  # fault after printing "10000"
  if [[ $(($1 % 5000)) -eq 0 ]]; then
      echo $1;
  elif [[ $1 -gt 10000 ]]; then
      echo $1
  fi
  recurse $(($1 + 1))
}

recurse 0
