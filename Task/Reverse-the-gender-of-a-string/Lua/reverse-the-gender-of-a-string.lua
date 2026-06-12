function sufficient(s)
  local xref = { She="He", He="She" }
  return (s:gsub("(%w+)", function(s) return xref[s] or s end))
end
s = "She was a soul stripper. She took my heart!"
print(sufficient(s))
print(sufficient(sufficient(s)))
print(sufficient(sufficient(s)) == s)
