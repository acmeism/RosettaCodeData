import "/str" for Str
import "/upc" for Graphemes

for (word in ["asdf", "josé", "møøse", "was it a car or a cat I saw", "😀🚂🦊"]) {
    System.print(Str.reverse(word))
}

for (word in ["as⃝df̅", "ℵΑΩ 駱駝道 🤔 🇸🇧 🇺🇸 🇬🇧‍ 👨‍👩‍👧‍👦🆗🗺"]) {
    System.print(Graphemes.new(word).toList[-1..0].join())
}
