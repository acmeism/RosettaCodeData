(off *MyIndex)

(use Word
   (for File '("file1" "file2" "file3")
      (in File
         (while (skip)
            (if (idx '*MyIndex (setq Word (till " ^I^J^M" T)) T)
               (push1 (car @) File)
               (set Word (cons File)) ) ) ) ) )

(de searchFor @
   (apply sect
      (extract
         '((Word) (val (car (idx '*MyIndex Word))))
         (rest) ) ) )
