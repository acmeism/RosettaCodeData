' Monty Hall problem

Public Sub MontyHallMain()
  Const NGames As Integer = 10000
  Dim NWins, Game As Integer
  Randomize
  NWins = 0
  For Game = 1 To NGames
    If IsGameWon(False) Then NWins = NWins + 1
  Next Game
  Debug.Print "NOT switching doors wins car in ";
  Debug.Print FormatNumber(NWins / NGames * 100, 1);
  Debug.Print "% of games."
  NWins = 0
  For Game = 1 To NGames
    If IsGameWon(True) Then NWins = NWins + 1
  Next Game
  Debug.Print "But switching doors wins car in ";
  Debug.Print FormatNumber(NWins / NGames * 100, 1);
  Debug.Print "% of games."
End Sub

Private Function IsGameWon(Sw As Boolean) As Boolean
  Dim Car, Player, Player0, Monty As Byte
  Car = Int(Rnd * 3) ' Randomly place car behind a door.
  Player0 = Int(Rnd * 3) ' Player randomly chooses a door.
  Do
    Monty = Int(Rnd * 3) ' Monty opens door revealing a goat.
  Loop Until (Monty <> Car) And (Monty <> Player0)
  If Sw <> 0 Then ' Player switches to remaining door.
    Do
      Player = Int(Rnd * 3)
    Loop Until (Player <> Player0) And (Player <> Monty)
  Else
    Player = Player0 ' Player sticks with original door.
  End If
  IsGameWon = (Player = Car)
End Function
