: (Sdigit) 0 swap begin base @ /mod >r + r> dup 0= until drop ;
: digiroot 0 swap begin (Sdigit) >r 1+ r> dup base @ < until ;
