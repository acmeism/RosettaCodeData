Const MAX_HYGIENE = 5
Const MAX_AGE = 30
Const MAX_BOREDOM = 5
Const MAX_HUNGER = 5
Const MAX_DIGESTION = 5

Enum PetStatus
    STATUS_OK, STATUS_BORED, STATUS_HUNGRY, STATUS_DIRTY, STATUS_OLD, STATUS_DEAD
End Enum

Type Tama
    As Integer hunger
    As Integer boredom
    As Integer age
    As Integer hygiene
    As Integer digestion
    As Integer pooped
End Type

Dim Shared pet As Tama

Sub Dump()
    Print "=== Pet Status ==="
    Print "Hunger:    "; pet.hunger & "/" & MAX_HUNGER
    Print "Boredom:   "; pet.boredom & "/" & MAX_BOREDOM
    Print "Age:       "; pet.age & "/" & MAX_AGE
    Print "Hygiene:   "; pet.hygiene & "/" & MAX_HYGIENE
    Print "Digestion: "; pet.digestion & "/" & MAX_DIGESTION
    Print "Pooped:    "; Iif(pet.pooped, "yes", "no")
    Print String (18, "=")
End Sub

Sub DiedFrom(reason As String, condition As Integer)
    If condition Then
        Print "tama died from "; reason
        Sleep
        End
    End If
End Sub

Sub Digest()
    If pet.digestion = 1 Then
        pet.pooped = 1
        pet.digestion = 0
        Print "tama poops!"
    Elseif pet.digestion = 0 Then
        pet.hunger += 1
        Print "tama's stomach growls"
    Else
        pet.digestion -= 1
    End If
End Sub

Sub UpdatePet()
    DiedFrom("boredom", pet.boredom > MAX_BOREDOM)
    DiedFrom("sickness", pet.hygiene < 1)
    DiedFrom("hunger", pet.hunger > MAX_HUNGER)
    DiedFrom("age", pet.age > MAX_AGE)
End Sub

Sub Spawn()
    Print "tama is born!"
    pet.hunger = 0
    pet.boredom = 0
    pet.age = 0
    pet.pooped = 0
    pet.hygiene = MAX_HYGIENE
    pet.digestion = MAX_DIGESTION
End Sub

Sub Wait_()
    Print "** time passes **"
    pet.boredom += 1
    pet.age += 1
    Digest()
    If pet.pooped Then pet.hygiene -= 1
    UpdatePet()
End Sub

Sub Look()
    If pet.boredom > 2 Then Print "tama looks bored"
    If pet.hygiene < MAX_HYGIENE Then Print "tama could use a wash"
    If pet.hunger > 0 Then Print "tama's stomach is grumbling"
    If pet.age > 20 Then Print "tama is getting long in the tooth"
    If pet.pooped Then Print "tama is disgusted by its own waste"
    If pet.boredom <= 2 And pet.hygiene >= MAX_HYGIENE And pet.hunger = 0 And _
    pet.age <= 20 And Not pet.pooped Then Print "tama looks fine"
End Sub

Sub Feed()
    If pet.hunger = 0 Then
        Print "tama bats the offered food away"
    Else
        Print "tama happily devours the offered food"
        pet.hunger = 0
        pet.digestion = MAX_DIGESTION
    End If
End Sub

Sub Clean()
    If Not pet.pooped Then
        Print "tama is clean enough already."
    Else
        Print "You dispose of the mess."
        pet.pooped = 0
        pet.hygiene = MAX_HYGIENE
    End If
End Sub

Sub Play()
    If pet.boredom = 0 Then
        Print "tama ignores you."
    Else
        Print "tama plays with you for a while."
        pet.boredom = 0
    End If
End Sub

' Main program
Print "You have a pet tamagotchi!"
Print "commands: WAIT LOOK FEED CLEAN PLAY"
Print "(secret commands: SPAWN DUMP)"
Spawn()
Look()

Dim As String cmd
Do
    Print !"\nEnter command: ";
    Input "", cmd

    Select Case Lcase(cmd)
    Case "wait" : Wait_()
    Case "look" : Look()
    Case "feed" : Feed()
    Case "clean": Clean()
    Case "play" : Play()
    Case "spawn": Spawn()
    Case "dump" : Dump()
    Case "exit" : Exit Do
    Case Else   : Print "Unknown command."
    End Select
Loop

Print !"\nGoodbye!"
End
