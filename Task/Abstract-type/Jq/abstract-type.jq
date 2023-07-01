def Beast::new($kind; $name): {
   superclass: "Beast",
   class: null,
   $kind,
   $name,
   cry: "unspecified"
};

def Ape::new($kind; $name):
  Beast::new($kind; $name)
  | .class = "Ape"
  | .cry = "Hoot";

def Cat::new($kind; $name):
  Beast::new($kind; $name)
  | .class = "Cat"
  | .cry = "Meow";

def Dog::new($kind; $name):
  Beast::new($kind; $name)
  | .class = "Dog"
  | .cry = "Woof";


def print:
  def a($noun):
    $noun
    | if .[0:1] | test("[aeio]") then "an \(.)" else "a \(.)" end;

  if .class == null
  then "\(.name) is \(a(.kind)), which is an unknown type of \(.superclass)."
  else "\(.name) is \(a(.kind)), a type of \(.class), and cries: \(.cry)."
  end;

Beast::new("sasquatch"; "Bigfoot"),
Ape::new("chimpanzee"; "Nim Chimsky"),
Dog::new("labrador"; "Max"),
Cat::new("siamese"; "Sammy")
| print
