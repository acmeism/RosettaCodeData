(de rdConf (File)
   (pipe (in File (while (echo "#" ";") (till "^J")))
      (while (read)
         (set @ (or (line T) T)) ) ) )
