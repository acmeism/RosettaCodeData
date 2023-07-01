(assert (integer? 42)) → #t ;; success returns true

;; error and return to top level if not true;
(assert (integer? 'quarante-deux))
⛔ error: assert : assertion failed : (#integer? 'quarante-deux)

;; assertion with message (optional)
(assert (integer? 'quarante-deux) "☝️ expression must evaluate to the integer 42")
💥 error: ☝️ expression must evaluate to the integer 42 : assertion failed : (#integer? 'quarante-deux)
