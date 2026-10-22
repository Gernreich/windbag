' PCHANTER.FRM
Option Explicit

Sub Cmd3dHalt_Click ()
extsub1A8
End Sub

Sub sub898 ()
extsub1A8
frmpinfo.Show 1
End Sub

Sub sub8D0 ()
Dim l001E As Variant
extsub1A8
l001E = FreeFile
Open Form1.Label8.Caption + "\chanter.txt" For Output As l001E
Write #l001E, HsbLG.Value, HsbLA.Value, HsbB.Value, HsbC.Value, HsbD.Value, HsbE.Value, HsbF.Value, HsbHG.Value, HsbHA.Value
Close l001E
pchanter.Hide
End Sub

Sub sub908 ()
extsub1A8
frmpinfo.Show 1
End Sub

Sub sub940 ()
extsub1A8
End Sub

Sub Command3_Click ()
extsub1A8
End Sub

Sub Command3D1_Click ()
Dim l0060 As Variant
extsub1A8
l0060 = FreeFile
Open Form1.Label8.Caption + "\chanter.txt" For Output As l0060
Write #l0060, HsbLG.Value, HsbLA.Value, HsbB.Value, HsbC.Value, HsbD.Value, HsbE.Value, HsbF.Value, HsbHG.Value, HsbHA.Value
Close l0060
pchanter.Hide
End Sub

Sub Command3D2_Click ()
extsub1A8
frmpinfo.Show 1
End Sub

Sub Form_Load ()
Dim l0064 As Variant
Dim l0068 As Variant
Dim l006C As Variant
Dim l0070 As Variant
Dim l0074 As Variant
Dim l0078 As Variant
Dim l007C As Variant
Dim l0080 As Variant
Dim l0084 As Variant
Dim l0088 As Variant
l0064 = FreeFile
Open Form1.Label8.Caption + "\chanter.txt" For Input As l0064
Input #l0064, l0068, l006C, l0070, l0074, l0078, l007C, l0080, l0084, l0088
Close l0064
HsbLG.Value = l0068
HsbLA.Value = l006C
HsbB.Value = l0070
HsbC.Value = l0074
HsbD.Value = l0078
HsbE.Value = l007C
HsbF.Value = l0080
HsbHG.Value = l0084
HsbHA.Value = l0088
extsub1A8
End Sub

Sub HsbB_Change ()
LblB.Caption = HsbB.Value
HsbC.Value = CInt(HsbB.Value * 10 / 9)
extsub170 (HsbB.Value)
End Sub

Sub HsbC_Change ()
LblC.Caption = HsbC.Value
HsbD.Value = CInt(HsbC.Value * 27 / 25)
extsub170 (HsbC.Value)
End Sub

Sub HsbD_Change ()
LblD.Caption = HsbD.Value
HsbE.Value = CInt(HsbD.Value * 10 / 9)
extsub170 (HsbD.Value)
End Sub

Sub HsbE_Change ()
LblE.Caption = HsbE.Value
HsbF.Value = CInt(HsbE.Value * 10 / 9)
extsub170 (HsbE.Value)
End Sub

Sub HsbF_Change ()
LblF.Caption = HsbF.Value
HsbHG.Value = CInt(HsbF.Value * 27 / 25)
extsub170 (HsbF.Value)
End Sub

Sub HsbHA_Change ()
LblHA.Caption = HsbHA.Value
extsub170 (HsbHA.Value)
End Sub

Sub HsbHG_Change ()
LblHG.Caption = HsbHG.Value
HsbHA.Value = CInt(HsbHG.Value * 10 / 9)
extsub170 (HsbHG.Value)
End Sub

Sub HsbLA_Change ()
LblLA.Caption = HsbLA.Value
HsbB.Value = CInt(HsbLA.Value * 9 / 8)
extsub170 (HsbLA.Value)
End Sub

Sub HsbLG_Change ()
lblLG.Caption = HsbLG.Value
HsbLA.Value = CInt(HsbLG.Value * 9 / 8)
extsub170 (HsbLG.Value)
End Sub

Sub subC50 ()
extsub1A8
End Sub
