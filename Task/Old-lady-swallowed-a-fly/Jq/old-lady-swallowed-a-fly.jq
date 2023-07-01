def animals:
  ["fly", "spider", "bird", "cat", "dog", "goat", "cow", "horse"];

def phrases: [
    null,
    "That wriggled and jiggled and tickled inside her",
    "How absurd to swallow a bird",
    "Fancy that to swallow a cat",
    "What a hog, to swallow a dog",
    "She just opened her throat and swallowed a goat",
    "I don't know how she swallowed a cow",
    "\n  ...She's dead of course"
];

def sing:
  def cond(q; x): select(q) | x;
  range(0;8)
  | "There was an old lady who swallowed a \(animals[.]);",
    cond(. > 0; "\(phrases[.])"),
    cond(. < 7;
      "",
      cond(. > 0;
        range(.; 0; -1) as $j
        | "  She swallowed the \(animals[$j]) to catch the \(
               animals[$j - 1])\(if $j < 3 then ";" else "," end)",
          cond($j == 2;  "  \(phrases[1])!") ),
      "  I don't know why she swallowed a fly - Perhaps she'll die!\n" );

sing
