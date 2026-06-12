# automatic schwartzian transform
dd <Rosetta Code is a programming chrestomathy site>.sort: *.chars;

# explicit schwartzian transform
dd <Rosetta Code is a programming chrestomathy site>.map({$_=>.chars}).sort({$^one.value cmp $^the-other.value}).map({.key});
