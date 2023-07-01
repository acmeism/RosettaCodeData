(let (Date (date)  Lst (date Date))
   (prinl (dat$ Date "-"))             # 2010-02-19
   (prinl                              # Friday, February 19, 2010
      (day Date)
      ", "
      (get *MonFmt (cadr Lst))
      " "
      (caddr Lst)
      ", "
      (car Lst) ) )
