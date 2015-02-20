procedure main()

   write("Matching s2 :=",image(s2 := "ab")," within s1:= ",image(s1 := "abcdabab"))

   write("Test #1 beginning ",if match(s2,s1) then "matches " else "failed")
   writes("Test #2 all matches at positions [")
      every writes(" ",find(s2,s1)|"]\n")
   write("Test #3 ending ", if s1[0-:*s2] == s2 then "matches" else "fails")

end
