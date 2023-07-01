(de rdConf (File)
   (in File
      (while (read)
         (set @ (or (pack (clip (line))) T)) ) ) )

(rdConf "conf.txt")
(println FULLNAME FAVOURITEFRUIT NEEDSPEELING SEEDSREMOVED OTHERFAMILY)
(bye)
