(load "@lib/xml.l")

(de characterRemarks (Names Remarks)
   (xml
      (cons
         'CharacterRemarks
         NIL
         (mapcar
            '((Name Remark)
               (list 'Character (list (cons 'name Name)) Remark) )
            Names
            Remarks ) ) ) )

(characterRemarks
   '("April" "Tam O'Shanter" "Emily")
   (quote
      "I'm > Tam and <= Emily"
      "Burns: \"When chapman billies leave the street ..."
      "Short & shrift" ) )
