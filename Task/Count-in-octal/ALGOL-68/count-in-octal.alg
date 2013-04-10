#!/usr/local/bin/a68g --script #

INT oct width = (bits width-1) OVER 3 + 1;
main:
(
  FOR i TO 17 # max int # DO
    printf(($"8r"8r n(oct width)dl$, BIN i))
  OD
)
