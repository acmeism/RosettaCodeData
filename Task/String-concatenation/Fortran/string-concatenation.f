program StringConcatenation

integer, parameter          :: maxstringlength = 64
character (maxstringlength) :: s1, s = "hello"

print *,s // " literal"
s1 = trim(s) // " literal"
print *,s1

end program
