/* ft=rexx */
/* GET3.RX - Display contents of an URL on the terminal. */
/* Usage: rexx get3.rx http://rosettacode.org            */
parse arg url .
address system 'curl' url with output fifo ''
address system 'more' with input fifo ''
