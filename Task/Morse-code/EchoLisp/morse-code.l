(require 'json)
(require 'hash)
(require 'timer)

;; json table from RUBY
(define morse-alphabet
#'{"0":"-----","1":".----","2":"..---","3":"...--","4":"....-","5":".....","6":"-....","7":"--...","8":"---..","9":"----.","!":"---.","$":"...-..-","'":".----.","(":"-.--.",")":"-.--.-","+":".-.-.",",":"--..--","-":"-....-",".":".-.-.-","/":"-..-.",":":"---...",";":"-.-.-.","=":"-...-","?":"..--..","@":".--.-.","A":".-","B":"-...","C":"-.-.","D":"-..","E":".","F":"..-.","G":"--.","H":"....","I":"..","J":".---","K":"-.-","L":".-..","M":"--","N":"-.","O":"---","P":".--.","Q":"--.-","R":".-.","S":"...","T":"-","U":"..-","V":"...-","W":".--","X":"-..-","Y":"-.--","Z":"--..","[":"-.--.","]":"-.--.-","_":"..--.-"," ":"|"}'#)

(define MORSE (json->hash (string->json morse-alphabet)))

;; translates a string into morse string
;; use "|" as letters separator
(define (string->morse str morse)
(apply append (map string->list
	(for/list [(a (string-diacritics str))]
		(string-append
		(or (hash-ref morse (string-upcase a)) "?") "|")))))
	
(define (play-morse)
	(when EMIT ;; else return #f which stops (at-every)
		(case  (first EMIT)
		((".") (play-sound 'digit) (write "dot"))
		(("-") (play-sound 'tick) (write "dash"))
		(else (writeln) (blink)))
		(set! EMIT (rest EMIT))))
