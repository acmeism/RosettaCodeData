USE: literals

CONSTANT: mammals { "mammals" { "deer" "gorilla" "dolphin" } }
CONSTANT: reptiles { "reptiles" { "turtle" "lizard" "snake" } }

{ "animals" ${ mammals reptiles } } dup . 10 margin set .
