set {dog, |Dog|, |DOG|} to {"Benjamin", "Samba", "Bernie"}

if (dog = |Dog|) then
    if (dog = |DOG|) then return "There is just one dog named " & dog & "."
    return "There are two dogs named " & dog & " and " & |DOG| & "."
else if (dog = |DOG|) then
    return "There are two dogs named " & dog & " and " & |Dog| & "."
end if
return "The three dogs are named " & dog & ", " & |Dog| & ", and " & |DOG| & "."
