: !n negate swap 1 dup rot do i * over +loop nip ;
: test cr 6 1 ?do 11 1 ?do i j !n . loop cr loop ;
