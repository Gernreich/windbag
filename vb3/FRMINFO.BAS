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
