#lang racket

(define sample
  #<<EOS
this URI contains an illegal character, parentheses and a misplaced full stop:
http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).
and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
")" is handled the wrong way by the mediawiki parser.
ftp://domain.name/path(balanced_brackets)/foo.html
ftp://domain.name/path(balanced_brackets)/ending.in.dot.
ftp://domain.name/path(unbalanced_brackets/ending.in.dot.
leading junk ftp://domain.name/path/embedded?punct/uation.
leading junk ftp://domain.name/dangling_close_paren)
EOS
  )

(define uri-ere-bits
  '("[a-z][-a-z0-9+.]*:"              ; Scheme...
    "(?=[/\\w])"                      ; ... but not just the scheme
    "(?://[-\\w.@:]+)?"               ; Host
    "[-\\w.~/%!$&'()*+,;=]*"          ; Path
    "(?:\\?[-\\w.~%!$&'()*+,;=/?]*)?" ; Query
    "(?:[#][-\\w.~%!$&'()*+,;=/?]*)?" ; Fragment
    ))

(define uri-re (pregexp (apply string-append uri-ere-bits)))

(for-each (compose displayln ~s) (regexp-match* uri-re sample))
(regexp-match-positions* uri-re sample)

(module+ test
  ;; "ABNF for Syntax Specifications" http://tools.ietf.org/html/rfc2234
  ;; defines ALPHA as:
  ;;   ALPHA = %x41-5A / %x61-7A   ; A-Z / a-z
  (unless (= 228 (char->integer #\ä))
    (error "a-umlaut is not 228, and therefore might be an ALPHA")))
