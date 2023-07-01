(de deleteLines (File Start Cnt)
   (let L (in File (make (until (eof) (link (line)))))
      (if (> (+ (dec 'Start) Cnt) (length L))
         (quit "Not enough lines")
         (out File
            (mapc prinl (cut Start 'L))
            (mapc prinl (nth L (inc Cnt))) ) ) ) )
