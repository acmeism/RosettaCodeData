CL-USER>(print-tree '(a
              (aa
               (aaa
                (aaaa)
                (aaab
                 (aaaba)
                 (aaabb))
                (aaac)))
              (ab)
              (ac
               (aca)
               (acb)
               (acc)))
            #'car #'cdr)
A
├─ AA
│  └─ AAA
│     ├─ AAAA
│     ├─ AAAB
│     │  ├─ AAABA
│     │  └─ AAABB
│     └─ AAAC
├─ AB
└─ AC
   ├─ ACA
   ├─ ACB
   └─ ACC
