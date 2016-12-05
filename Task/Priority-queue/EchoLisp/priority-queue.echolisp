(lib 'tree)
(define tasks (make-bin-tree 3 "Clear drains"))
(bin-tree-insert tasks 2 "Tax return")
(bin-tree-insert tasks 5 "Make tea")
(bin-tree-insert tasks 1 "Solve RC tasks")
(bin-tree-insert tasks 4 "Feed 🐡")

(bin-tree-pop-first tasks) → (1 . "Solve RC tasks")
(bin-tree-pop-first tasks) → (2 . "Tax return")
(bin-tree-pop-first tasks) → (3 . "Clear drains")
(bin-tree-pop-first tasks) → (4 . "Feed 🐡")
(bin-tree-pop-first tasks) → (5 . "Make tea")
(bin-tree-pop-first tasks) → null

;; similarly
(bin-tree-pop-last tasks) → (5 . "Make tea")
(bin-tree-pop-last tasks) → (4 . "Feed 🐡")
; etc.
