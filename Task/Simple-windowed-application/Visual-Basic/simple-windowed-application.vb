VERSION 5.00
Begin VB.Form Form2
   Caption         =   "There have been no clicks yet"
   ClientHeight    =   2940
   ClientLeft      =   60
   ClientTop       =   600
   ClientWidth     =   8340
   LinkTopic       =   "Form1"
   ScaleHeight     =   2940
   ScaleWidth      =   8340
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1
      Caption         =   "Click me!"
      Height          =   495
      Left            =   3600
      TabIndex        =   0
      Top             =   1200
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----user-written code begins here; everything above this line is hidden in the GUI-----
Private clicked As Long

Private Sub Command1_Click()
    clicked = clicked + 1
    Me.Caption = clicked & " clicks."
End Sub
