Red [
  file: %morse.red   ;; filename, could be ommited
]
; ";" is character for comment, i use double ones for better readability

DIT: 100 ;; constant : 100 ms for short Beep
FREQ: 700 ;; frequency for Beep

;; exported code for red/system win api calls to Beep / Sleep:
#include %api.reds

;; string with morse codes for alphabet:
;; ( caution, u must use "str: copy ..."  if code ist to be executed multiple times ! )
str: "A.-B-...C-.-.D-..E.F..-.G--.H....I..J.---K-.-L.-..M--N-."
append str "O---P.--.Q--.-R.-.S...T-U..-V...-W.--X-..-Y-.--Z--.."

 delim: charset [#"A" - #"Z"]

 ;; use of parse to generate "mc" morse code series / array containing codes for A - Z
 ;; use characters only as delimiter for each code
 mc:  parse str [ thru "A"  collect some [ keep copy result to [delim | end ] skip ] ]

  ;;--------------------------------------------
 send-code: func ["function to play morse code for character "
 ;;--------------------------------------------
           chr [char!]  ;; character A .. Z
      ][
      sleep 500           ;; short break so u can read the character first
      ind:   to-integer chr - 64 ;; calculate index for morse array
      foreach sym mc/:ind [     ;; foreach symbol of code for character ...
        prin sym                  ;; prin(t) "." or "-"
        either sym = #"." [     ;; short beep
          beep FREQ DIT
      ][
        beep FREQ 3 * DIT     ;; or long beep = 3 x short
      ]
      sleep DIT                   ;; short break after each character
    ]
]
 ;;----------------------------------------------
 morse-text: func ["extract valid characters from sentence"
 ;;----------------------------------------------
        msg [string!]
][
 foreach chr uppercase msg [
    prin  chr prin " "    ;; print character
  ;; valid character  A-Z ?
   either   (chr >= #"A") and (chr <= #"Z") [
      send-code chr
    ] [          ;; ... "else" word gap or unknown
      sleep 6 * DIT   ;; pause after word
    ]
    prin newline    ;; equal to :  print """ ,( prin prints without crlf )
  ]
  sleep 6 * DIT  ;; pause after sentence
 ]
 ;;----------------------------------

morse-text "rosetta code"
morse-text "hello world"
