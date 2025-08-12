;; Define the three series
list1: [a b c]
list2: [A B C]
list3: [1 2 3]

;; Iterate over them in parallel by index
repeat i length? list1 [
    ;; pick returns the i-th element
    print rejoin [list1/:i list2/:i list3/:i]
]
