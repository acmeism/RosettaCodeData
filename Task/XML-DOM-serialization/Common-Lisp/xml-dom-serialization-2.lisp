(let ((doc (dom:create-document 'rune-dom:implementation nil nil nil)))
  (dom:append-child
   (dom:append-child
    (dom:append-child doc (dom:create-element doc "root"))
    (dom:create-element doc "element"))
   (dom:create-text-node doc "Some text here"))
  (write-string (dom:map-document (cxml:make-rod-sink) doc)))
