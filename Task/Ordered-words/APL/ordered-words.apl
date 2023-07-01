result←longest_ordered_words file_path

f←file_path ⎕NTIE 0            ⍝ open file
text←⎕NREAD f 'char8'          ⍝ read vector of 8bit chars
⎕NUNTIE f                      ⍝ close file

lines←text⊂⍨~text∊(⎕UCS 10 13) ⍝ split into lines (\r\n)

⍝ filter only words with ordered characters
ordered_words←lines/⍨{(⍳∘≢≡⍋)⍵}¨lines

⍝ find max of word lengths, filter only words with that length
result←ordered_words/⍨lengths=⍨⌈/lengths←≢¨ordered_words
