# Return a cons pair of address and port: (address . port)
(de ipAddress (Adr)
   (use (@A @B @C @D @Port)
      (cond
         ((match '("[" @A "]" ":" @Port) Adr)
            (adrIPv6 (split @A ":") @Port) )
         ((match '("[" @A "]") Adr)
            (adrIPv6 (split @A ":")) )
         ((match '(@A ":" @B ":" @C) Adr)
            (adrIPv6 (cons @A @B (split @C ":"))) )
         ((match '(@A "." @B "." @C "." @D ":" @Port) Adr)
            (adrIPv4 (list @A @B @C @D) @Port) )
         ((match '(@A "." @B "." @C "." @D) Adr)
            (adrIPv4 (list @A @B @C @D)) )
         (T (quit "Bad IP address" (pack Adr))) ) ) )

(de adrIPv4 (Lst Port)
   (cons
      (sum >> (-24 -16 -8 0) (mapcar format Lst))
      (format Port) ) )

(de adrIPv6 (Lst Port)
   (cons
      (sum >>
         (-112 -96 -80 -64 -48 -32 -16 0)
         (mapcan
            '((X)
               (if X
                  (cons (hex X))
                  (need (- 9 (length Lst)) 0) ) )  # Handle '::'
            (cons (or (car Lst) "0") (cdr Lst)) ) )
      (format Port) ) )
