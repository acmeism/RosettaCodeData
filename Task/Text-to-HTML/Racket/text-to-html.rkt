#lang at-exp racket

(require ffi/unsafe ffi/unsafe/define)

(define-ffi-definer defcmark (ffi-lib "libcmark"))

(define _cmark_opts
  (_bitmask '(sourcepos = 1 hardbreaks = 2 normalize = 4 smart = 8)))
(define-cpointer-type _node)
(defcmark cmark_markdown_to_html
  (_fun [bs : _bytes] [_int = (bytes-length bs)] _cmark_opts
        -> [r : _bytes] -> (begin0 (bytes->string/utf-8 r) (free r))))

(define (cmark-markdown-to-html #:options [opts '(normalize smart)] . text)
    (cmark_markdown_to_html (string->bytes/utf-8 (string-append* text)) opts))

(display @cmark-markdown-to-html{
  This is
  a paragraph

      a block of
      code

  * A one-bullet list
    > With quoted text
    >
    >     and code
})
