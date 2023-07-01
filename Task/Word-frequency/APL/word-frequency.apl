⍝⍝ NOTE: input text is assumed to be encoded in ISO-8859-1
⍝⍝ (The suggested example '135-0.txt' of Les Miserables on
⍝⍝ Project Gutenberg is in UTF-8.)
⍝⍝
⍝⍝ Use Unix 'iconv' if required
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
∇r ← lowerAndStrip s;stripped;mixedCase
 ⍝⍝ Convert text to lowercase, punctuation and newlines to spaces
 stripped ← '               abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz*'
 mixedCase ← ⎕av[11],' ,.?!;:"''()[]-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
 r ← stripped[mixedCase ⍳ s]
∇

⍝⍝ Return the _n_ most frequent words and a count of their occurrences
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
∇r ← n wordCount fname ;D;wl;sidx;swv;pv;wc;uw;sortOrder
  D ← lowerAndStrip (⎕fio['read_file'] fname)  ⍝ raw text with newlines
  wl ← (~ D ∊ ' ') ⊂ D
  sidx ← ⍒wl
  swv ← wl[sidx]
  pv ← +\ 1,~2 ≡/ swv
  wc ← ∊ ⍴¨ pv ⊂ pv
  uw ← 1 ⊃¨ pv ⊂ swv
  sortOrder ← ⍒wc
  r ← n↑[2] uw[sortOrder],[0.5]wc[sortOrder]
∇

      5 wordCount '135-0.txt'
   the    of   and     a    to
 41042 19952 14938 14526 13942
