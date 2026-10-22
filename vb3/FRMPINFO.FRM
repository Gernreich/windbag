VERSION 2.00
Begin Form frmpinfo 
   Caption         =   "Info Page"
   ClientHeight    =   1335
   ClientLeft      =   4035
   ClientTop       =   3120
   ClientWidth     =   1935
   Height          =   1740
   Left            =   3975
   LinkTopic       =   "Form2"
   ScaleHeight     =   1335
   ScaleWidth      =   1935
   Top             =   2775
   Width           =   2055
   Begin CommandButton Command2 
      Caption         =   "Read Me"
      Height          =   495
      Left            =   360
      TabIndex        =   1
      Top             =   120
      Width           =   1215
   End
   Begin CommandButton Command1 
      Caption         =   "About "
      Height          =   495
      Left            =   360
      TabIndex        =   0
      Top             =   720
      Width           =   1215
   End
End
' FRMPINFO.FRM
Option Explicit

Sub Command1_Click ()
MsgBox ("Written by Michael Carnright.  Send comments to (address removed)")
End Sub

Sub Command2_Click ()
Dim l001A As Variant
l001A = Shell("notepad .\readme.2nd", 3)
End Sub
