/* ft=rexx */
/* GET2.RX - Display contents of an URL on the terminal. */
/* Usage: rexx get2.rx http://rosettacode.org            */
parse arg url .
address system 'curl' url with output stem stuff.
do i = 1 to stuff.0
  say stuff.i
end
