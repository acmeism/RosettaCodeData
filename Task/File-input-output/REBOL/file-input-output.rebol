write %output.txt read %input.txt

; No line translations:
write/binary %output.txt read/binary %input.txt

; Save a web page:
write/binary %output.html read http://rosettacode.org
