(for-each
  (lambda (s) (print (string-join (reverse (string-split s #/ +/)))))
  (string-split
    "---------- Ice and Fire ------------

    fire, in end will world the say Some
    ice. in say Some
    desire of tasted I've what From
    fire. favor who those with hold I

    ... elided paragraph last ...

    Frost Robert -----------------------"
    #/[ \r]*\n[ \r]*/))
