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
   Begin VB.CommandButton cmdDec
      Caption         =   "Decrement"
      Enabled         =   0   'False
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
'-----user-written code begins here; everything above this line is hidden in the GUI-----
Private Sub cmdDec_Click()
    If Val(txtValue.Text) > 0 Then txtValue.Text = Val(txtValue.Text) - 1
End Sub

Private Sub cmdInc_Click()
    If Val(txtValue.Text) < 10 Then txtValue.Text = Val(txtValue.Text) + 1
End Sub

Private Sub txtValue_Change()
    Select Case Val(txtValue.Text)
        Case Is < 0
            txtValue.Enabled = False
            cmdInc.Enabled = True
            cmdDec.Enabled = False
        Case Is > 9
            txtValue.Enabled = False
            cmdInc.Enabled = False
            cmdDec.Enabled = True
        Case 0
            txtValue.Enabled = True
            cmdInc.Enabled = True
            cmdDec.Enabled = False
        Case Else
            txtValue.Enabled = False
            cmdInc.Enabled = True
            cmdDec.Enabled = True
    End Select
End Sub
