task←{
   ⍝ Collapse a string
   collapse←{(1,¯1↓⍵≠1⌽⍵)/⍵}

   ⍝ Given a function ⍺⍺, display a string in brackets,
   ⍝ along with its length, and do the same for the result
   ⍝ of applying ⍺⍺ to the string.
   display←{
      bracket←{(⍕⍴⍵),' «««',⍵,'»»»'}
      ↑(⊂bracket ⍵),(⊂bracket ⍺⍺ ⍵)
   }

   ⍝ Strings from the task
   s1←''
   s2←'"If I were two-faced, would I be wearing this one?"'
   s2,←' --- Abraham Lincoln '
   s3←'..1111111111111111111111111111111111111111111111111'
   s3,←'111111111111117777888'
   s4←'I never give ''em hell, I just tell the truth, '
   s4,←'and they think it''s hell. '
   s5←'                                             '
   s5,←'       --- Harry S Truman  '
   strs←s1 s2 s3 s4 s5

   ⍝ Collapse each string and display it as specified
   ↑collapse display¨ strs
}
