module ReverseGender

const MARKER = "\0"

const words = "^" .* ["She", "she", "Her",  "her",  "hers", "He",   "he",   "His",  "his",  "him"] .* "\$" .|> Regex
const repls = ["He", "he", "His", "his" ,"his", "She", "she", "Her", "her", "her"] .* MARKER

function reverse(s::AbstractString)
    for (w, r) in zip(words, repls)
        s = replace(s, w => r)
    end
    return replace(s, MARKER => "")
end

end  # module ReverseGender

@show ReverseGender.reverse("She was a soul stripper. She took his heart!")
@show ReverseGender.reverse("He was a soul stripper. He took her heart!")
@show ReverseGender.reverse("She wants what's hers, he wants her and she wants him!")
@show ReverseGender.reverse("Her dog belongs to him but his dog is hers!")
