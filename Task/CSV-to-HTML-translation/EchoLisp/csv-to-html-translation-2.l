;; changed <angry> to <b> to show that html tags inside text are correctly transmitted.
(define MontyPython #<<
    Character,Speech
    The multitude,The messiah! Show us the messiah!
    Brians mother,<b>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</b>
    The multitude,Who are you?
    Brians mother,I'm his mother; that's who!
    The multitude,Behold his mother! Behold his mother!
>>#)

(define (task speech)
	(define table (csv->table speech))
	(stack html)
	(emit-tag 'table h-table table)
	(html-dump))
	
(task MontyPython)
