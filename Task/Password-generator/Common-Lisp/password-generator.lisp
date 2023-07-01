(defvar *lowercase* '(#\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m
                      #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z))

(defvar *uppercase* '(#\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M
                      #\N #\O #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z))

(defvar *numbers* '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))

(defvar *special-characters* '(#\! #\\ #\# #\$ #\% #\& #\' #\( #\) #\*
                              #\+ #\, #\- #\. #\/ #\: #\; #\< #\= #\>
                              #\? #\@ #\[ #\] #\^ #\_ #\{ #\| #\} #\~))

(defvar *similar-characters* '(#\I #\l #\1 #\| #\O #\0 #\5 #\S #\2 #\Z))

(defun make-readable (s)
  (remove-if (lambda (x) (member x *similar-characters*)) s))

(defun shuffle-list (input-list)
  (loop with l = (length input-list)
     for i below l
     do (rotatef (nth i input-list)
         (nth (random l) input-list)))
  input-list)

(defun generate-password (len human-readable)
  (let*
    ((upper (if human-readable (make-readable *uppercase*) *uppercase*))
    (lower (if human-readable (make-readable *lowercase*) *lowercase*))
    (number (if human-readable (make-readable *numbers*) *numbers*))
    (special (if human-readable (make-readable *special-characters*) *special-characters*))
    (character-groups (list upper lower number special))
    (initial-password (reduce (lambda (acc x)
      (cons (nth (random (length x)) x) acc))
      character-groups :initial-value NIL)))

    (coerce (shuffle-list (reduce (lambda (acc x)
      (declare (ignore x))
      (let ((group (nth (random (length character-groups)) character-groups)))
        (cons (nth (random (length group)) group) acc)))
      (make-list (- len 4)) :initial-value initial-password)) 'string)))

(defun main (len count &optional human-readable)
  (if (< len 4)
    (print "Length must be at least 4~%")
    (loop for x from 1 to count do
      (print (generate-password len human-readable)))))
