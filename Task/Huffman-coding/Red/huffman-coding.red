Red [file: %huffy.red]

;; message to encode:
msg: "this is an example for huffman encoding"

;;map to collect leave knots  per uniq character of message
m: make map! []	

knot: make object! [
	left: right: none    ;; pointer to left/right sibling
	code: none        ;; first holds char for debugging, later binary code
	count: depth: 1     ;;occurence of character - length of branch
]

;;-----------------------------------------
set-code: func  ["recursive function to generate binary code sequence"
			wknot
			wcode [string!]] [
;;-----------------------------------------
	either wknot/left = none [
		wknot/code:  wcode
	] [
		set-code wknot/left rejoin [wcode "1"]
		set-code wknot/right rejoin [wcode "0"]
	]
]	;;-- end func

;-------------------------------
merge-2knots: func ["function to merge 2 knots into 1 new"
	t [block!]][
;-------------------------------
	nknot: copy knot      ;; create new knot
	nknot/count:  t/1/count + t/2/count
	nknot/right: t/1
	nknot/left: t/2
	nknot/depth: t/1/depth + 1
	tab: remove/part t 2	;; delete first 2 knots
	insert t nknot  ;; insert new generated knot
]	;;-- end func

;; count occurence of characters, save in map: m
foreach chr msg [
	either k:  select/case m chr [
			k/count: k/count + 1	
	][
		put/case m chr nknot: copy knot
		nknot/code: chr
	]
]

;; create sortable block (=tab) for use as prio queue
foreach k  keys-of m [	append tab: []  :m/:k ]

;; build tree
while [ 1 <  length? tab][
	sort/compare tab function [a b] [
					a/count  <  b/count
		  or (   a/count = b/count and ( a/depth > b/depth ) )
	]
	merge-2knots tab	;; merge 2 knots with lowest count / max depth
]

set-code tab/1 ""		;; generate binary codes, save at leave knot

;;  display codes
foreach k sort keys-of m [
	print [k " = " m/:k/code]	
	append codes: "" m/:k/code	
]

;; encode orig message string
foreach chr msg [
	k: select/case m chr
	 append msg-new: ""   k/code
]

print [ "length of encoded msg "  length? msg-new]
print [ "length of (binary) codes "  length? codes ]

print ["orig. message: "  msg newline "encoded message: " "^/" msg-new]
prin "decoded: "

;; decode message (destructive! ):
while [ not empty? msg-new ][
  foreach [k v] body-of   m [
    if  t: find/match msg-new v/code   [
      prin k
      msg-new: t
    ]
  ]
 ]
