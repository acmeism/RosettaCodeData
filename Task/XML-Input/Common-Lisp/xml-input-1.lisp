(defparameter *xml-blob*
"<Students>
  <Student Name=\"April\" Gender=\"F\" DateOfBirth=\"1989-01-02\" />
  <Student Name=\"Bob\" Gender=\"M\"  DateOfBirth=\"1990-03-04\" />
  <Student Name=\"Chad\" Gender=\"M\"  DateOfBirth=\"1991-05-06\" />
  <Student Name=\"Dave\" Gender=\"M\"  DateOfBirth=\"1992-07-08\">
    <Pet Type=\"dog\" Name=\"Rover\" />
  </Student>
  <Student DateOfBirth=\"1993-09-10\" Gender=\"F\" Name=\"&#x00C9;mily\" />
</Students>")

(let* ((document (cxml:parse *xml-blob* (cxml-dom:make-dom-builder)))
       (students (dom:item (dom:get-elements-by-tag-name document "Students") 0))
       (student-names '()))
  (dom:do-node-list (child (dom:child-nodes students) (nreverse student-names))
    (when (dom:element-p child)
      (push (dom:get-attribute child "Name") student-names))))
