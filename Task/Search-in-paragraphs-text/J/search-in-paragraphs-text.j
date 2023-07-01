NB. read file, separate on blank lines
paragraphs=: ((LF,LF)&E. <;.2 ])fread 'traceback.txt'

NB. ignore text preceding 'Traceback (most recent call last)'
cleaned=:  {{y}.~{.I.'Traceback (most recent call last)'&E.y}}each paragraphs

NB. limit to paragraphs containing 'SystemError'
searched=: (#~ (1 e.'SystemError'&E.)every) cleaned

NB. add "paragraph 'separator'" and display
echo ;searched ,L:0 '----------------',LF
