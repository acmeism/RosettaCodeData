Red [needs: 'view]

CRLF: copy "^M^/" ;; constant for 0D 0A line feed
;;------------------------------------
crypt: func ["function to en- or decrypt message from textarea tx1"
    /decrypt "decrypting switch/refinement" ][
;;------------------------------------

;; when decrypting we have to remove the superflous newlines
;; and undo the base64 encoding first ...
txt: either decrypt [     ;; message to en- or decrypt
   s: copy tx1/text
   ;; newline could be single 0a byte or crlf sequence when copied from clipboard...
   debase replace/all s either find s CRLF  [CRLF ] [ newline ] ""
] [
    tx1/text ;; plaintext message
]

txt: to-binary txt          ;; handle message as binary
key: to-binary key1/text  ;; handle key also as binary

bin: copy either decrypt [  ""  ][ #{} ] ;; buffer for output

code: copy #{} ;; temp field to collect utf8 bytes when decrypting

;; loop over  length of binary! message ...
repeat pos length? txt [
 k: to-integer key/(1 + modulo pos length? key)   ;; get corresponding key byte
 c: to-integer txt/:pos       ;; get integer value from message byte at position pos

 either decrypt [                         ;; decrypting ?
    c:  modulo ( 256 + c - k ) 256      ;; compute original byte value
    case [
      ;; byte starting with 11.... ( >= 192 dec ) is utf8 startbyte
      ;; byte starting with 10... ( >= 128 dec) is utf8 follow up byte , below is single ascii byte
        ( c >= 192 ) or ( c < 128 )  [    ;; starting utf8 sequence byte or below 128 normal ascii ?
            ;; append last code to buffer, maybe normal ascii or utf8 sequence...
            if not empty? code [ append bin to-char code ]  ;; save previous code first
            code: append copy #{} c     ;; start new code
        ]
        true [ append code c ]  ;; otherwise utf8 follow up byte, append to startbyte
      ]
  ][
    append bin modulo ( c + k ) 256   ;; encrypting , simply collect binary bytes
  ]
] ;; close repeat loop

either decrypt [                ;; collect utf-8 characters
   append bin to-char code    ;; append last code
  tx2/text: to-string bin      ;; create valid utf8 string when decrypting
][  ;; base64 encoding of crypted binary to get readable text string...
    s: enbase copy  bin      ;; base 64 is default
    while [40 < length? s ] [ ;; insert newlines for better "readability"
        s: skip s either head? s [40][41]   ;; ... every 40 characters
        insert s newline
    ]
    tx2/text: head s    ;; reset s pointing to head again
  ]
]
;----------------------------------------------------------
; start of program
;----------------------------------------------------------
view layout [title  "vigenere cyphre"	;Define nice GUI :- )
;----------------------------------------------------------
  backdrop silver      ;; define window background colour
  text "message:" pad 99x1 button "get-clip" [tx1/text: read-clipboard]
  ;; code in brackets will be executed, when button is clicked:
  button "clear" [tx1/text: copy "" ] return
  tx1: area  330x80 "" return
  text 25x20  "Key:" key1:  field 290x20 "secretkey" return
  button "crypt" [crypt ]  button "decrypt" [crypt/decrypt ]
  button "swap" [tx1/text: copy tx2/text tx2/text: copy "" ] return
  text "de-/encrypted message:" pad 50x1  button "copy clip"  [ write-clipboard tx2/text]
  button "clear" [tx2/text: copy "" ] return
  tx2: area  330x100 return
  pad 270x1 button "Quit " [quit]
]
