DICT = %w( α a    . β b v      . γ g . δ d   . ε e    . ζ z     . η h ee . θ th .
           ι i j  . κ c k q ck . λ l . μ m   . ν n    . ξ x     . ο o    . π p  .
           ρ r rh . σ s        . τ t . υ u y . φ f ph . χ ch kh . ψ ps   . ω w oo)
       .chunks(&.==(".")).each_step(2).map {|_, l| l[1..].map {|e| { e, l.first } } }
       .flatten.to_h

RE = Regex.union DICT.keys.sort_by {|k| -k.size}.map {|k| Regex.literal k, i: true }

def transliterate (s)
  s.gsub(RE) {|s|
    replacement = DICT[s.downcase]
    replacement = replacement.upcase if s[0].uppercase?
    replacement
  }
    .gsub(/σ\b/, "ς")
end

text = <<-EOT
I was looking at some rhododendrons in my back garden,
dressed in my khaki shorts, when the telephone rang.

As I answered it, I cheerfully glimpsed that the July sun
caused a fragment of black pine wax to ooze on the velvet quilt
laying in my patio.
EOT

puts transliterate(text)
