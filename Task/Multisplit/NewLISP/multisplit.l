(define (multi-split str seps)
  (let (parsed
          (find-all
            (string {((.*?)(} (join (map string seps) "|")  {))|(.+)$})
            str
            (if (= "" $3) (list $4) (list $2 $3))))
    (list parsed (map first parsed))))

(multi-split "a!===b=!=c" '(== != =))
