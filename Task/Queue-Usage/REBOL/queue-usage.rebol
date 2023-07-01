; Create and populate a FIFO:

q: make fifo []
q/push 'a
q/push 2
q/push USD$12.34              ; Did I mention that REBOL has 'money!' datatype?
q/push [Athos Porthos Aramis] ; List elements pushed on one by one.
q/push [[Huey Dewey Lewey]]   ; This list is preserved as a list.

; Dump it out, with narrative:

print rejoin ["Queue is "  either q/empty [""]["not "]  "empty."]
while [not q/empty][print ["  " q/pop]]
print rejoin ["Queue is "  either q/empty [""]["not "]  "empty."]
print ["Trying to pop an empty queue yields:" q/pop]
