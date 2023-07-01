VERSION 5.00
Begin VB.Form Form1
   Begin VB.Timer Timer1
      Interval = 250
   End
   Begin VB.Label Label1
      AutoSize = -1  'True
      Caption  = "Hello World! "
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Everything above this line is hidden when in the IDE.

Private goRight As Boolean

Private Sub Label1_Click()
    goRight = Not goRight
End Sub

Private Sub Timer1_Timer()
    If goRight Then
        x = Mid(Label1.Caption, 2) & Left(Label1.Caption, 1)
    Else
        x = Right(Label1.Caption, 1) & Left(Label1.Caption, Len(Label1.Caption) - 1)
    End If
    Label1.Caption = x
End Sub
