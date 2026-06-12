(de extension (F)
   (and
      (fully
         '((C)
            (or
               (>= "Z" C "A")
               (>= "z" C "a")
               (>= "9" C "0") ) )
      (setq F (stem (member "." (chop F)) ".")) )
      (pack F) ) )
(println (extension "http://example.com/download.tar.gz"))
(println (extension "CharacterModel.3DS"))
(println (extension ".desktop"))
(println (extension "document"))
(println (extension "document.txt_backup"))
(println (extension "/etc/pam.d/login"))
