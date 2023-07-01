VERSION 5.00
Begin VB.Form Form1
   Caption         =   "Form1"
   ClientHeight    =   2265
   ClientLeft      =   60
   ClientTop       =   600
   ClientWidth     =   2175
   LinkTopic       =   "Form1"
   ScaleHeight     =   2265
   ScaleWidth      =   2175
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdRnd
      Caption         =   "Random"
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   1680
      Width           =   1215
   End
   Begin VB.CommandButton cmdInc
      Caption         =   "Increment"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   1080
      Width           =   1215
   End
   Begin VB.TextBox txtValue
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Text            =   "0"
      Top             =   240
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----user-written code begins here; everything above this line is hidden in the IDE-----
Private Sub Form_Load()
    Randomize Timer
End Sub

Private Sub cmdRnd_Click()
    If MsgBox("Random?", vbYesNo) Then txtValue.Text = Int(Rnd * 11)
End Sub

Private Sub cmdInc_Click()
    If Val(txtValue.Text) < 10 Then txtValue.Text = Val(txtValue.Text) + 1
End Sub

Private Sub txtValue_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8, 43, 45, 48 To 57
            'backspace, +, -, or number
        Case Else
            KeyAscii = 0
    End Select
End Sub
