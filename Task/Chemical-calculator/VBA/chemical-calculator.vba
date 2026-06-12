Option Explicit

Enum ParsingStateCode
    NORM
    GROUP_JUST_ENDED
End Enum

Dim masses As Collection

Sub main()
    Dim molecule
    For Each molecule In Array("H", "H2", "H2O", "H2O2", "(HO)2", "Na2SO4", "C6H12", "COOH(C(CH3)2)3CH3", _
    "C6H4O2(OH)4", "C27H46O", "Uue")
        Debug.Print molecule; Tab(20); GetMM(molecule)
    Next
End Sub

Function GetMM(ByVal f As String) As Double
    If masses Is Nothing Then init
    f = f & "@"
    Dim pos As Long
    Dim mass(5) As Double
    For pos = 1 To Len(f)
        Dim sym$: sym = Mid(f, pos, 1)
        Select Case sym
        Case "A" To "Z"
            GoSub calc
            Dim atom$: atom = sym
        Case "a" To "z"
            atom = atom & sym
        Case "("
            GoSub calc
            Dim depth As Long: depth = depth + 1
        Case ")"
            GoSub calc
            Dim parsingState As ParsingStateCode
            parsingState = GROUP_JUST_ENDED
        Case 0 To 9
            Dim nStr As String
            nStr = nStr & sym
        Case "@"
            GoSub calc
        End Select
    Next
    GetMM = mass(0)
Exit Function
'-------------------------------------------------------------------
calc:
    Dim n As Long
    If nStr = "" Then
        n = 1
    Else
        n = CLng(nStr)
    End If
    Select Case parsingState
    Case NORM
        mass(depth) = mass(depth) + masses(atom) * n
        atom = ""
    Case GROUP_JUST_ENDED
        mass(depth) = mass(depth) * n
        depth = depth - 1
        mass(depth) = mass(depth) + mass(depth + 1)
        parsingState = NORM
    End Select
    'n = 0
    nStr = ""
Return
End Function

Sub init()
    Set masses = New Collection
    masses.Add 0, ""
    masses.Add 1.008, "H"
    masses.Add 4.002602, "He"
    masses.Add 6.94, "Li"
    masses.Add 9.0121831, "Be"
    masses.Add 10.81, "B"
    masses.Add 12.011, "C"
    masses.Add 14.007, "N"
    masses.Add 15.999, "O"
    masses.Add 18.998403163, "F"
    masses.Add 20.1797, "Ne"
    masses.Add 22.98976928, "Na"
    masses.Add 24.305, "Mg"
    masses.Add 26.9815385, "Al"
    masses.Add 28.085, "Si"
    masses.Add 30.973761998, "P"
    masses.Add 32.06, "S"
    masses.Add 35.45, "Cl"
    masses.Add 39.0983, "K"
    masses.Add 39.948, "Ar"
    masses.Add 40.078, "Ca"
    masses.Add 44.955908, "Sc"
    masses.Add 47.867, "Ti"
    masses.Add 50.9415, "V"
    masses.Add 51.9961, "Cr"
    masses.Add 54.938044, "Mn"
    masses.Add 55.845, "Fe"
    masses.Add 58.6934, "Ni"
    masses.Add 58.933194, "Co"
    masses.Add 63.546, "Cu"
    masses.Add 65.38, "Zn"
    masses.Add 69.723, "Ga"
    masses.Add 72.63, "Ge"
    masses.Add 74.921595, "As"
    masses.Add 78.971, "Se"
    masses.Add 79.904, "Br"
    masses.Add 83.798, "Kr"
    masses.Add 85.4678, "Rb"
    masses.Add 87.62, "Sr"
    masses.Add 88.90584, "Y"
    masses.Add 91.224, "Zr"
    masses.Add 92.90637, "Nb"
    masses.Add 95.95, "Mo"
    masses.Add 101.07, "Ru"
    masses.Add 102.9055, "Rh"
    masses.Add 106.42, "Pd"
    masses.Add 107.8682, "Ag"
    masses.Add 112.414, "Cd"
    masses.Add 114.818, "In"
    masses.Add 118.71, "Sn"
    masses.Add 121.76, "Sb"
    masses.Add 126.90447, "I"
    masses.Add 127.6, "Te"
    masses.Add 131.293, "Xe"
    masses.Add 132.90545196, "Cs"
    masses.Add 137.327, "Ba"
    masses.Add 138.90547, "La"
    masses.Add 140.116, "Ce"
    masses.Add 140.90766, "Pr"
    masses.Add 144.242, "Nd"
    masses.Add 145, "Pm"
    masses.Add 150.36, "Sm"
    masses.Add 151.964, "Eu"
    masses.Add 157.25, "Gd"
    masses.Add 158.92535, "Tb"
    masses.Add 162.5, "Dy"
    masses.Add 164.93033, "Ho"
    masses.Add 167.259, "Er"
    masses.Add 168.93422, "Tm"
    masses.Add 173.054, "Yb"
    masses.Add 174.9668, "Lu"
    masses.Add 178.49, "Hf"
    masses.Add 180.94788, "Ta"
    masses.Add 183.84, "W"
    masses.Add 186.207, "Re"
    masses.Add 190.23, "Os"
    masses.Add 192.217, "Ir"
    masses.Add 195.084, "Pt"
    masses.Add 196.966569, "Au"
    masses.Add 200.592, "Hg"
    masses.Add 204.38, "Tl"
    masses.Add 207.2, "Pb"
    masses.Add 208.9804, "Bi"
    masses.Add 209, "Po"
    masses.Add 210, "At"
    masses.Add 222, "Rn"
    masses.Add 223, "Fr"
    masses.Add 226, "Ra"
    masses.Add 227, "Ac"
    masses.Add 231.03588, "Pa"
    masses.Add 232.0377, "Th"
    masses.Add 237, "Np"
    masses.Add 238.02891, "U"
    masses.Add 243, "Am"
    masses.Add 244, "Pu"
    masses.Add 247, "Cm"
    masses.Add 247, "Bk"
    masses.Add 251, "Cf"
    masses.Add 252, "Es"
    masses.Add 257, "Fm"
    masses.Add 299, "Ubn"
    masses.Add 315, "Uue"
End Sub
