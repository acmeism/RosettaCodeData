(setq
   *Boys (list
      (de abe  abi eve cath ivy jan dee fay bea hope gay)
      (de bob  cath hope abi dee eve fay bea jan ivy gay)
      (de col  hope eve abi dee bea fay ivy gay cath jan)
      (de dan  ivy fay dee gay hope eve jan bea cath abi)
      (de ed   jan dee bea cath fay eve abi ivy hope gay)
      (de fred bea abi dee gay eve ivy cath jan hope fay)
      (de gav  gay eve ivy bea cath abi dee hope jan fay)
      (de hal  abi eve hope fay ivy cath jan bea gay dee)
      (de ian  hope cath dee gay bea abi fay ivy jan eve)
      (de jon  abi fay jan gay eve bea dee cath ivy hope) )
   *Girls (list
      (de bi   bob fred jon gav ian abe dan ed col hal)
      (de bea  bob abe col fred gav dan ian ed jon hal)
      (de cath fred bob ed gav hal col ian abe dan jon)
      (de dee  fred jon col abe ian hal gav dan bob ed)
      (de eve  jon hal fred dan abe gav col ed ian bob)
      (de fay  bob abe ed ian jon dan fred gav col hal)
      (de gay  jon gav hal fred bob abe col ed dan ian)
      (de hope gav jon bob abe ian dan hal ed col fred)
      (de ivy  ian col hal gav fred bob abe ed jon dan)
      (de jan  ed hal gav abe bob jon col ian fred dan) )
   *Couples NIL )

(bind *Boys
   (while
      (find
         '((Boy) (and (val Boy) (not (asoq Boy *Couples))))
         *Boys )
      (let (Boy @  Girl (pop Boy)  Pair (find '((P) (== Girl (cdr P))) *Couples))
         (nond
            (Pair (push '*Couples (cons Boy Girl)))   # Girl is free
            ((memq Boy (memq (car Pair) (val Girl)))  # Girl prefers Boy
               (set Pair Boy) ) ) ) ) )

(for Pair *Couples
   (prinl (cdr Pair) " is engaged to " (car Pair)) )

(de checkCouples ()
   (unless
      (filter
         '((Pair)
            (let (Boy (car Pair)  Girl (cdr Pair))
               (find
                  '((B)
                     (and
                        (memq Boy (cdr (memq B (val Girl))))  # Girl prefers B
                        (memq
                           (cdr (asoq B *Couples))            # and B prefers Girl
                           (cdr (memq Girl (val B))) )
                        (prinl
                           Girl " likes " B " better than " Boy " and "
                           B " likes " Girl " better than "
                           (cdr (asoq B *Couples)) ) ) )
                  (val Girl) ) ) )
         *Couples )
      (prinl "All marriages are stable") ) )

(checkCouples)
(prinl)
(prinl "Engage fred with abi and jon with bea")
(con (asoq 'fred *Couples) 'abi)
(con (asoq 'jon *Couples) 'bea)
(checkCouples)
