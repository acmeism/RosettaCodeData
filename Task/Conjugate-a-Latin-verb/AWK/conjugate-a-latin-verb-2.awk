#!/bin/sh

printf '
# "āre" Verbs (1st Conjugation):
amare (to love)
laudare (to praise)
vocare (to call)

# "ēre" Verbs (2nd Conjugation):
vidēre (to see)
docēre (to teach)
legere (to read)

# "ere" Verbs (3rd Conjugation):
ducere (to lead)
capere (to take)
facere (to do/make)

# "īre" Verbs (4th Conjugation):
audire (to hear)
venire (to come)
ire (to go)

# incorrect verbs
qwerty

' '' | LANG=en_US.UTF-8 gawk -f ./clv.awk
