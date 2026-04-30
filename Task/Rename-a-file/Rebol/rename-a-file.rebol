rename %input.txt %output.txt
rename %docs/ %mydocs/

; Unix. Note that there's no path specification used for the
; new name. "Rename" is not "move".

rename %/input.txt %output.txt
rename %/docs/ %mydocs/

; DOS/Windows:

rename %/c/input.txt %output.txt
rename %/c/docs/ %mydocs/

; Because REBOL treats data access schemes as uniformly as possible,
; you can do tricks like this:

rename ftp://username:password@ftp.site.com/www/input.txt %output.txt
rename ftp://username:password@ftp.site.com/www/docs/ %mydocs/
