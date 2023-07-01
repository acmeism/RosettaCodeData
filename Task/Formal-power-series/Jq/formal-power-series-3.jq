def factorial:
  reduce range(1; . + 1) as $i
    (1; . * $i);
