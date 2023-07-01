(and
   (call 'sh "-c"
      (pack
         "dialog \
            --inputbox 'Input a string' 8 60 \
            --inputbox 'Input a number' 8 20 \
            2>"
         (tmp "dlg") ) )
   (split (in (tmp "dlg") (line)) "^I")
   (cons (pack (car @)) (format (cadr @))) )
