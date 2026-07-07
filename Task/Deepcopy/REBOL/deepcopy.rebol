Rebol [
    title: "Rosetta code: Deepcopy"
    file:  %Deepcopy.r3
    url:   https://rosettacode.org/wiki/Deepcopy
]

person1: ["Tesla" 10-July-1856 Serbian children: []]
;; Deep copy the person to person2
person2: copy/deep person1
;; Modify person2
insert person2/1 "Nikola "
append person2/children "Angelina"
;; Check results
probe person1 ;; not modified
probe person2 ;; modifiled person
print "-----"

;; Making an object from a template also deep copies:
bob: object [name: "Bob" children: []]
eva: make bob []
change eva/name "Eva"
append eva/children "John"
? bob ;; still no children
? eva ;; has a child
