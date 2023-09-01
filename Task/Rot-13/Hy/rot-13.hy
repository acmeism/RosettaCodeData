#!/usr/bin/env hy
(require hyrule [defmain])

(setv lowers (lfor *x* (range 26)
                   (chr (+ *x* (ord "a")))))  ; generate latin lower 26 chars
(setv uppers (list (map str.upper lowers)))   ; and the upper case
(setv lowers (list (map ord lowers)))         ; convert to unicode codepoints
(setv uppers (list (map ord uppers)))
(setv translations                            ; a dictionary with from->to
      (dict (zip                              ; codepoint mapping
        (+ lowers uppers)
        (+ (cut lowers 13 None)
           (cut lowers 0 13)
           (cut uppers 13 None)
           (cut uppers 0 13)))))

(defn rot13 [string]
  (return (.translate string translations)))

(defmain []
  (import fileinput)
  (for [*line* (fileinput.input)]
  (print (rot13 *line*) :end "")))
