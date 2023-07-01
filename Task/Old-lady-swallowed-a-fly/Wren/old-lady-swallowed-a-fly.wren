var animals = ["fly", "spider", "bird", "cat","dog", "goat", "cow", "horse"]

var phrases = [
    "",
    "That wriggled and jiggled and tickled inside her",
    "How absurd to swallow a bird",
    "Fancy that to swallow a cat",
    "What a hog, to swallow a dog",
    "She just opened her throat and swallowed a goat",
    "I don't know how she swallowed a cow",
    "\n  ...She's dead of course"
]

var sing = Fn.new {
     for (i in 0..7) {
       System.print("There was an old lady who swallowed a %(animals[i]);")
       if (i > 0) System.print("%(phrases[i])!")
       if (i == 7) return
       System.print()
       if (i > 0) {
           for (j in i..1) {
               System.write("  She swallowed the %(animals[j]) to catch the %(animals[j - 1])")
               System.print((j < 3) ? ";" :",")
               if (j == 2) System.print("  %(phrases[1])!")
           }
       }
       System.print("  I don't know why she swallowed a fly - Perhaps she'll die!\n")
    }
}

sing.call()
