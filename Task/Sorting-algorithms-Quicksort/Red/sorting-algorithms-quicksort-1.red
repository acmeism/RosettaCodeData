Red []

;;-------------------------------
;; we have to use function not func here, otherwise we'd have to define all "vars" as local...
qsort: function [list][
;;-------------------------------
  if 1 >= length? list [  return list ]
  left: copy []
  right: copy []
  eq:   copy []  ;; "equal"
  pivot: list/2 ;; simply choose second element as pivot element
  foreach ele list [
      case [
       ele < pivot [ append left ele ]
       ele > pivot [ append right ele ]
       true        [ append eq ele ]
      ]
  ]
  ;; this is the last expression of the function, so coding "return" here is not necessary
  ;reduce [qsort left eq qsort right] ; NOTE: This internally produced a nested list like this:
  ; [[] [1 1 1] [[[2] [3 3 3] [4]] [7] [8]]]
  ; Although printing it displayed as normal, internally it's not, so I (hinjolicious) corrected it to this:
  append append qsort left eq qsort right ; corrected!
  ; Note though that this will still caused stack overflow on sorted / reversed data!
]


;; lets test the function with an array of 100k integers, range 1..1000
list: []
loop 100000 [append list random 1000]
t0: now/time/precise  ;; start timestamp
qsort list ;; the return value (block) contains the sorted list, original list has not changed
print ["time1: "  now/time/precise   - t0]  ;; about 1.1 sec on my machine
t0: now/time/precise
sort list  ;; just for fun time the builtin function also ( also implementation of quicksort )
print ["time2: " now/time/precise   - t0]
