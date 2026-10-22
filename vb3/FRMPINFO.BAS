' FRMPINFO.FRM
Option Explicit

Sub Command1_Click ()
MsgBox ("Written by Michael Carnright.  Send comments to (address removed)")
End Sub

Sub Command2_Click ()
Dim l001A As Variant
l001A = Shell("notepad .\readme.2nd", 3)
End Sub
