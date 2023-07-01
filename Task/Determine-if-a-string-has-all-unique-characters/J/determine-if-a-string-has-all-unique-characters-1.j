rc_unique=: monad define
 string=. '"' , y , '"'
 self_classification=. = y  NB. deprecated- consumes space proportional to the squared tally of y  (*: # y)
 is_unique=. self_classification =&# y
 if. is_unique do.
  (# y) ; string ; 'unique'
 else.
  duplicate_masks=. (#~ (1 < +/"1)) self_classification
  duplicate_characters=. ~. y #~ +./ duplicate_masks
  ASCII_values_of_duplicates=. a. i. duplicate_characters
  markers=. duplicate_masks { ' ^'
  A=. (# y) ; string , ' ' ,. markers
  B=. 'duplicate' , ASCII_values_of_duplicates ('<' , (#~ 31&<)~ , '> ASCII ' , ":@:[)"0 duplicate_characters
  A , < B
 end.
)
