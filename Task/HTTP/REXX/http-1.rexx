/* ft=rexx */
/* GET2.RX - Display contents of an URL on the terminal. */
/* Usage: rexx get.rx http://rosettacode.org             */
parse arg url .
'curl' url
