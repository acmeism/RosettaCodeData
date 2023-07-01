let
  str='AöЖ€𝄞'
 ,countofcodeunits=str.length // 6
 ,cparr=[...str],
 ,countofcodepoints=cparr.length; // 5
{ let
    count=0
  for(let codepoint of str)
    count++
  countofcodepoints=count // 5
}
{ let
    count=0,
    it=str[Symbol.iterator]()
  while(!it.next().done)
    count++
  countofcodepoints=count // 5
}
{ cparr=Array.from(str)
  countofcodepoints=cparr.length // 5
}
