; Common whitespace characters
(defvar *whitespace* '(#\Space #\Newline #\Tab))

(defvar str "   foo bar     baz  ")

(string-trim *whitespace* str)
; -> "foo bar     baz"

(string-left-trim *whitespace* str)
; -> "foo bar     baz  "

(string-right-trim *whitespace* str)
; -> "   foo bar     baz"

; Whitespace characters defined by Unicode for
; implementations which support it (e.g. CLISP, SBCL).
; (see http://www.unicode.org/Public/UCD/latest/ucd/PropList.txt)
(defvar *unicode-whitespace*
  '(#\u0009 #\u000a #\u000b #\u000c #\u000d
    #\u0020 #\u0085 #\u00a0 #\u1680 #\u2000
    #\u2001 #\u2002 #\u2003 #\u2004 #\u2005
    #\u2006 #\u2007 #\u2008 #\u2009 #\u200a
    #\u2028 #\u2029 #\u202f #\u205f #\u3000))

(defvar unicode-str
  (format nil "~C~Cfoo~Cbar~Cbaz~C~C"
          #\u2000 #\u2003 #\u0020 #\u00a0 #\u0009 #\u202f))

(string-trim *unicode-whitespace* unicode-str)
; -> "foo bar baz"

(string-left-trim *unicode-whitespace* unicode-str)
; -> "foo bar baz     "

(string-right-trim *unicode-whitespace* unicode-str)
; -> "  foo bar baz"
