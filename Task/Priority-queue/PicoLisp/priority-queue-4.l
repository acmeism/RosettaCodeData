(setq H NIL)
(for
   Task '(
      (3 . "Clear drains.")
      (4 . "Feed cat.")
      (5 . "Make tea.")
      (1 . "Solve RC tasks.")
      (2 . "Tax Return."))
   (setq H (heap-insert Task H)))

(while H
   (prinl (caar H) ". " (cdar H))
   (setq H (heap-rest H)))

(bye)
