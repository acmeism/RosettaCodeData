use AppleScript version "2.4" -- Mac OS X 10.10 (Yosemite) or later.

on getName under category : "Misc: " given firstName:firstName : "?", lastName:lastName : "?", comma:comma : true
    if (comma) then
        return category & firstName & ", " & lastName
    else
        return category & firstName & space & lastName
    end if
end getName

getName given lastName:"Doe"
--> "Misc: ?, Doe"
