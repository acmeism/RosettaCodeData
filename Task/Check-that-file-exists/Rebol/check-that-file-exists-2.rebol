exists? %title.png
;== file
exists? %/
;== dir
exists? %not-existing
;== #(none)
exists? %`Abdu'l-Bahá.txt
;== #(none)
write %`Abdu'l-Bahá.txt "Hello"
;== %`Abdu'l-Bahá.txt
exists? %`Abdu'l-Bahá.txt
;== file
delete %`Abdu'l-Bahá.txt
