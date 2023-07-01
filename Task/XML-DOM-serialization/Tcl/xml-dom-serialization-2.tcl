package require dom
set doc [dom::DOMImplementation create]
set root [dom::document createElement $doc root]
set elem [dom::document createElement $root element]
set text [dom::document createTextNode $elem "Some text here"]
dom::DOMImplementation serialize $doc -newline {element}
