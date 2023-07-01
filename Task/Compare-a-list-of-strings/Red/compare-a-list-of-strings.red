Red []

list1: ["asdf" "Asdf" "asdf"]
list2: ["asdf" "bsdf" "asdf"]
list3: ["asdf" "asdf" "asdf"]

all-equal?: func [list][   1 = length? unique/case list  ]
sorted?: func [list][   list == sort/case copy list ]  ;; sort without copy would modify list !

print all-equal? list1
print sorted? list1

print all-equal? list2
print sorted? list2

print all-equal? list3
print sorted? list3
