s1 = "abcd"
s2 = "adab"
s3 = "ab"

String.starts_with?(s1, s3)
# => true
String.starts_with?(s2, s3)
# => false

String.contains?(s1, s3)
# => true
String.contains?(s2, s3)
# => true

String.ends_with?(s1, s3)
# => false
String.ends_with?(s2, s3)
# => true


# Optional requirements:
Regex.run(~r/#{s3}/, s1, return: :index)
# => [{0, 2}]
Regex.run(~r/#{s3}/, s2, return: :index)
# => [{2, 2}]

Regex.scan(~r/#{s3}/, "abcabc", return: :index)
# => [[{0, 2}], [{3, 2}]]
