on getName given firstName:firstName, lastName:lastName, comma:comma
    if (comma) then
        return firstName & ", " & lastName
    else
        return firstName & space & lastName
    end if
end getName

getName given lastName:"Doe", firstName:"John" comma:true -- compiles as: getName with comma given lastName:"Doe", firstName:"John"
--> "John, Doe"
getName without comma given lastName:"Doe", firstName:"John"
--> "John Doe"
