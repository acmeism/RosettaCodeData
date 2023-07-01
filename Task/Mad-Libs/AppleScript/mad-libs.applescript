set theNoun to the text returned of (display dialog "What is your noun?" default answer "")

set thePerson to the text returned of (display dialog "What is the person's name?" default answer "")

set theGender to the text returned of (display dialog "He or she? Please capitalize." default answer "")

display dialog thePerson & " went for a walk in the park. " & theGender & " found a " & theNoun & ".  " & thePerson & " decided to take it home."
