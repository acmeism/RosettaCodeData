try
    set num to 1 / 0
    --do something that might throw an error
on error errMess number errNum
    --errMess and number errNum are optional
    display alert "Error # " & errNum & return & errMess
end try
