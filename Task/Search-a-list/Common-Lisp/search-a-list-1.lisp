(let ((haystack '(Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo)))
  (dolist (needle '(Washington Bush))
    (let ((index (position needle haystack)))
      (if index
          (progn (print index) (princ needle))
          (progn (print needle) (princ "is not in haystack"))))))
