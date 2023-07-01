Red []
test: func [ s][
p: copy "BOXKDQCPNAGTRETGQDFSJWHUVIANOBERFSLYPCZM"
forever [
    if 0 = length? s [  return  'true   ]               ;; if string cleared, all chars found/removed
    if tail? p  [  return 'false   ]                      ;; if at end of search block - not found
    rule: reduce [  first p  '| second p]                 ;; construct parse rule from string
    either parse s [  to rule remove rule to end ] [    ;; remove found char from string
      remove/part p 2                                     ;;character found , remove block
      p: head p                                             ;;start from remaining string at beginning aka head
    ] [  p: skip p 2  ]                                      ;; else move to next block
]
]
foreach word split {A bark book TrEAT COmMoN SQUAD conFUsE}  space [
  print reduce [ pad copy word 8 ":" test word]
 ]
