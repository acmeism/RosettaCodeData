'This is the string we want to "evolve" to. Any string of any length will
'do as long as it consists only of upper case letters and spaces.

Target  = "METHINKS IT IS LIKE A WEASEL"

'This is the pool of letters that will be selected at random for a mutation

letters = " ABCDEFGHIJKLMNOPQRSTUVWXYZ"

'A mutation rate of 0.5 means that there is a 50% chance that one letter
'will be mutated at random in the next child

mutation_rate = 0.5

'Set for 10 children per generation

Dim child(10)

'Generate the first guess as random letters

Randomize
Parent = ""

for i = 1 to len(Target)
    Parent = Parent & Mid(letters,Random(1,Len(letters)),1)
next

gen = 0

Do
    bestfit = 0
    bestind = 0

    gen = gen + 1

    'make n copies of the current string and find the one
    'that best matches the target string

    For i = 0 to ubound(child)

        child(i) = Mutate(Parent, mutation_rate)

        fit = Fitness(Target, child(i))

        If fit > bestfit Then
            bestfit = fit
            bestind = i
        End If

    Next

    'Select the child that has the best fit with the target string

    Parent = child(bestind)
    Wscript.Echo parent, "(fit=" & bestfit & ")"

Loop Until Parent = Target

Wscript.Echo vbcrlf & "Generations = " & gen

'apply a random mutation to a random character in a string

Function Mutate ( ByVal str , ByVal rate )

    Dim pos        'a random position in the string'
    Dim ltr        'a new letter chosen at random    '

    If rate > Rnd(1) Then

        ltr = Mid(letters,Random(1,len(letters)),1)
        pos = Random(1,len(str))
        str = Left(str, pos - 1) & ltr & Mid(str, pos + 1)

    End If

    Mutate = str

End Function

'returns the number of letters in the two strings that match

Function Fitness (ByVal str , ByVal ref )

    Dim i

    Fitness = 0

    For i = 1 To Len(str)
        If Mid(str, i, 1) = Mid(ref, i, 1) Then Fitness = Fitness + 1
    Next

End Function

'Return a random integer in the range lower to upper (inclusive)

Private Function Random ( lower , upper )
  Random = Int((upper - lower + 1) * Rnd + lower)
End Function
