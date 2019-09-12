Option Base 1
Public Enum attr
    Colour = 1
    Nationality
    Beverage
    Smoke
    Pet
End Enum
Public Enum Drinks_
    Beer = 1
    Coffee
    Milk
    Tea
    Water
End Enum
Public Enum nations
    Danish = 1
    English
    German
    Norwegian
    Swedish
End Enum
Public Enum colors
    Blue = 1
    Green
    Red
    White
    Yellow
End Enum
Public Enum tobaccos
    Blend = 1
    BlueMaster
    Dunhill
    PallMall
    Prince
End Enum
Public Enum animals
    Bird = 1
    Cat
    Dog
    Horse
    Zebra
End Enum
Public permutation As New Collection
Public perm(5) As Variant
Const factorial5 = 120
Public Colours As Variant, Nationalities As Variant, Drinks As Variant, Smokes As Variant, Pets As Variant

Private Sub generate(n As Integer, A As Variant)
    If n = 1 Then
        permutation.Add A
    Else
        For i = 1 To n
            generate n - 1, A
            If n Mod 2 = 0 Then
                tmp = A(i)
                A(i) = A(n)
                A(n) = tmp
            Else
                tmp = A(1)
                A(1) = A(n)
                A(n) = tmp
            End If
        Next i
    End If
End Sub

Function house(i As Integer, name As Variant) As Integer
    Dim x As Integer
    For x = 1 To 5
        If perm(i)(x) = name Then
            house = x
            Exit For
        End If
    Next x
End Function

Function left_of(h1 As Integer, h2 As Integer) As Boolean
    left_of = (h1 - h2) = -1
End Function

Function next_to(h1 As Integer, h2 As Integer) As Boolean
    next_to = Abs(h1 - h2) = 1
End Function

Private Sub print_house(i As Integer)
    Debug.Print i & ": "; Colours(perm(Colour)(i)), Nationalities(perm(Nationality)(i)), _
        Drinks(perm(Beverage)(i)), Smokes(perm(Smoke)(i)), Pets(perm(Pet)(i))
End Sub
Public Sub Zebra_puzzle()
    Colours = [{"blue","green","red","white","yellow"}]
    Nationalities = [{"Dane","English","German","Norwegian","Swede"}]
    Drinks = [{"beer","coffee","milk","tea","water"}]
    Smokes = [{"Blend","Blue Master","Dunhill","Pall Mall","Prince"}]
    Pets = [{"birds","cats","dog","horse","zebra"}]
    Dim solperms As New Collection
    Dim solutions As Integer
    Dim b(5) As Integer, i As Integer
    For i = 1 To 5: b(i) = i: Next i
    'There are five houses.
    generate 5, b
    For c = 1 To factorial5
        perm(Colour) = permutation(c)
        'The green house is immediately to the left of the white house.
        If left_of(house(Colour, Green), house(Colour, White)) Then
            For n = 1 To factorial5
                perm(Nationality) = permutation(n)
                'The Norwegian lives in the first house.
                'The English man lives in the red house.
                'The Norwegian lives next to the blue house.
                If house(Nationality, Norwegian) = 1 _
                    And house(Nationality, English) = house(Colour, Red) _
                    And next_to(house(Nationality, Norwegian), house(Colour, Blue)) Then
                    For d = 1 To factorial5
                        perm(Beverage) = permutation(d)
                        'The Dane drinks tea.
                        'They drink coffee in the green house.
                        'In the middle house they drink milk.
                        If house(Nationality, Danish) = house(Beverage, Tea) _
                            And house(Beverage, Coffee) = house(Colour, Green) _
                            And house(Beverage, Milk) = 3 Then
                            For s = 1 To factorial5
                                perm(Smoke) = permutation(s)
                                'In the yellow house they smoke Dunhill.
                                'The German smokes Prince.
                                'The man who smokes Blue Master drinks beer.
                                'They Drink water in a house next to the house where they smoke Blend.
                                If house(Colour, Yellow) = house(Smoke, Dunhill) _
                                    And house(Nationality, German) = house(Smoke, Prince) _
                                    And house(Smoke, BlueMaster) = house(Beverage, Beer) _
                                    And next_to(house(Beverage, Water), house(Smoke, Blend)) Then
                                    For p = 1 To factorial5
                                        perm(Pet) = permutation(p)
                                        'The Swede has a dog.
                                        'The man who smokes Pall Mall has birds.
                                        'The man who smokes Blend lives in the house next to the house with cats.
                                        'In a house next to the house where they have a horse, they smoke Dunhill.
                                        If house(Nationality, Swedish) = house(Pet, Dog) _
                                            And house(Smoke, PallMall) = house(Pet, Bird) _
                                            And next_to(house(Smoke, Blend), house(Pet, Cat)) _
                                            And next_to(house(Pet, Horse), house(Smoke, Dunhill)) Then
                                            For i = 1 To 5
                                                print_house i
                                            Next i
                                            Debug.Print
                                            solutions = solutions + 1
                                            solperms.Add perm
                                        End If
                                    Next p
                                End If
                            Next s
                        End If
                    Next d
                End If
            Next n
        End If
    Next c
    Debug.Print Format(solutions, "@"); " solution" & IIf(solutions > 1, "s", "") & " found"
    For i = 1 To solperms.Count
        For j = 1 To 5
            perm(j) = solperms(i)(j)
        Next j
        Debug.Print "The " & Nationalities(perm(Nationality)(house(Pet, Zebra))) & " owns the Zebra"
    Next i
End Sub
