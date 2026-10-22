VERSION 2.00
Begin Form frminfo 
   Caption         =   "Info Page"
   ClientHeight    =   2535
   ClientLeft      =   3885
   ClientTop       =   2430
   ClientWidth     =   1935
   Height          =   2940
   Left            =   3825
   LinkTopic       =   "Form2"
   ScaleHeight     =   2535
   ScaleWidth      =   1935
   Top             =   2085
   Width           =   2055
   Begin CommandButton Command4 
      Caption         =   "wbg format"
      Height          =   495
      Left            =   360
      TabIndex        =   3
      Top             =   1320
      Width           =   1215
   End
   Begin CommandButton Command3 
      Caption         =   "Book List"
      Height          =   495
      Left            =   360
      TabIndex        =   2
      Top             =   720
      Width           =   1215
   End
   Begin CommandButton Command2 
      Caption         =   "About Win(d)bag"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   1920
      Width           =   1695
   End
   Begin CommandButton Command1 
      Caption         =   "Read Me"
      Height          =   495
      Left            =   360
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
' FRMINFO.FRM
Option Explicit
Const c0022 = 4096& ' &H1000&
Const c0026 = 4& ' &H4&
Const c002A = 2048& ' &H800&
Const c002E = 1 ' &H1%

Sub Command1_Click ()
Dim l001A As Variant
' Const c0022 = 4096& ' &H1000&
' Const c0026 = 4& ' &H4&
' Const c002A = 2048& ' &H800&
' Const c002E = 1 ' &H1%
l001A = Shell("notepad .\readme.1st", 3)
End Sub

Sub Command2_Click ()
MsgBox ("Written by Michael Carnright.  Send comments to (address removed)")
End Sub

Sub Command3_Click ()
Dim l0030 As Variant
Dim l0034 As Variant
Form1.CMDialog2.Filename = ""
Form1.CMDialog2.DefaultExt = "*.ndx"
Form1.CMDialog2.DialogTitle = "List of pipe tune books"
Form1.CMDialog2.Filter = "indexes|*.ndx|allfiles|*.*"
Form1.CMDialog2.FilterIndex = 1
Form1.CMDialog2.Flags = c0022 Or c0026 Or c002A
Form1.CMDialog2.Action = c002E
l0030 = "notepad " + Form1.CMDialog2.Filename
If  Form1.CMDialog2.Filename <> "" Then l0034 = Shell(l0030, 3)
End Sub

Sub Command4_Click ()
Dim l0038 As Variant
l0038 = Shell("notepad .\wbgfrmat.txt", 3)
End Sub
