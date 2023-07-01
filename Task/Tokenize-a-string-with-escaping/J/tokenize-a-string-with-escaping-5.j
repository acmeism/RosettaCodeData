   t=: 'one^|uno||three^^^^|four^^^|^cuatro|'

  tokenize t
┌───────┬┬───────┬────────────┬┐
│one|uno││three^^│four^|cuatro││
└───────┴┴───────┴────────────┴┘

   $tokenize t
5
