Red/System [
  file: %api.reds ;; filename, could be ommited
]

; --- lib import -----
;; for winapi functions "Beep" and "Sleep"
#system [ #import [  "kernel32.dll" stdcall [
      wbeep: "Beep" [
           frequ    [integer!]
           dur [integer!]
          return: [integer!]
       ]
         wsleep: "Sleep" [ dur [integer!]  ]
] ] ]

beep: routine [
        freq [integer!]
        duration [integer!]
        return: [integer!]
      ]  [ wbeep freq duration  ]

sleep: routine [
        duration [integer!]
      ]  [ wsleep duration  ]
;;----------------------------------------------
