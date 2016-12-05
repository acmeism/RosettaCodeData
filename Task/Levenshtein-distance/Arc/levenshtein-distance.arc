(def levenshtein (str1 str2)
  (withs l1  len.str1
         l2  len.str2
         row range0:inc.l1

    (times j l2
      (let next list.j
        (times i l1
          (push
            (inc:min
              car.next
              ((if (is str1.i str2.j) dec id) car.row)
              (car:zap cdr row))
            next))
        (= row nrev.next)))
    row.l1))
