VERSION 2.00
Begin Form pchanter 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Computer/Practice Chanter Alignment"
   ClientHeight    =   6510
   ClientLeft      =   2520
   ClientTop       =   420
   ClientWidth     =   4740
   Height          =   6915
   Left            =   2460
   LinkTopic       =   "Form2"
   ScaleHeight     =   6510
   ScaleWidth      =   4740
   Top             =   75
   Width           =   4860
   Begin SSCommand Command3D2 
      Caption         =   "?"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   18
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00000000&
      Height          =   735
      Left            =   2520
      TabIndex        =   29
      Top             =   5040
      Width           =   615
   End
   Begin SSCommand Command3D1 
      Height          =   735
      Left            =   1920
      Picture         =   PCHANTER.FRX:0000
      TabIndex        =   28
      Top             =   5040
      Width           =   615
   End
   Begin SSCommand Cmd3dHalt 
      Height          =   735
      Left            =   1320
      Picture         =   PCHANTER.FRX:0926
      TabIndex        =   27
      Top             =   5040
      Width           =   615
   End
   Begin HScrollBar HsbHA 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   1157
      Min             =   707
      TabIndex        =   8
      Top             =   600
      Value           =   933
      Width           =   3495
   End
   Begin HScrollBar HsbHG 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   1041
      Min             =   636
      TabIndex        =   7
      Top             =   1080
      Value           =   840
      Width           =   3495
   End
   Begin HScrollBar HsbF 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   964
      Min             =   589
      TabIndex        =   6
      Top             =   1560
      Value           =   778
      Width           =   3495
   End
   Begin HScrollBar HsbE 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   868
      Min             =   530
      TabIndex        =   5
      Top             =   2040
      Value           =   700
      Width           =   3495
   End
   Begin HScrollBar HsbD 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   781
      Min             =   477
      TabIndex        =   4
      Top             =   2520
      Value           =   630
      Width           =   3495
   End
   Begin HScrollBar HsbC 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   723
      Min             =   442
      TabIndex        =   3
      Top             =   3000
      Value           =   583
      Width           =   3495
   End
   Begin HScrollBar HsbB 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   651
      Min             =   398
      TabIndex        =   2
      Top             =   3480
      Value           =   525
      Width           =   3495
   End
   Begin HScrollBar HsbLA 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   579
      Min             =   354
      TabIndex        =   1
      Top             =   3960
      Value           =   467
      Width           =   3495
   End
   Begin HScrollBar HsbLG 
      Height          =   255
      LargeChange     =   10
      Left            =   480
      Max             =   515
      Min             =   315
      TabIndex        =   0
      Top             =   4440
      Value           =   415
      Width           =   3495
   End
   Begin Label Label18 
      Caption         =   "High A"
      Height          =   255
      Left            =   4080
      TabIndex        =   26
      Top             =   600
      Width           =   615
   End
   Begin Label Label17 
      Caption         =   "High G"
      Height          =   255
      Left            =   4080
      TabIndex        =   25
      Top             =   1080
      Width           =   615
   End
   Begin Label Label16 
      Caption         =   "F"
      Height          =   255
      Left            =   4080
      TabIndex        =   24
      Top             =   1560
      Width           =   135
   End
   Begin Label Label15 
      Caption         =   "E"
      Height          =   255
      Left            =   4080
      TabIndex        =   23
      Top             =   2040
      Width           =   135
   End
   Begin Label Label14 
      Caption         =   "D"
      Height          =   255
      Left            =   4080
      TabIndex        =   22
      Top             =   2520
      Width           =   135
   End
   Begin Label Label13 
      Caption         =   "C"
      Height          =   255
      Left            =   4080
      TabIndex        =   21
      Top             =   3000
      Width           =   135
   End
   Begin Label Label12 
      Caption         =   "B"
      Height          =   255
      Left            =   4080
      TabIndex        =   20
      Top             =   3480
      Width           =   135
   End
   Begin Label Label11 
      Caption         =   "Low A"
      Height          =   255
      Left            =   4080
      TabIndex        =   19
      Top             =   3960
      Width           =   615
   End
   Begin Label Label10 
      Caption         =   "Low G"
      Height          =   255
      Left            =   4080
      TabIndex        =   18
      Top             =   4440
      Width           =   615
   End
   Begin Label LblHA 
      Caption         =   "933"
      Height          =   255
      Left            =   0
      TabIndex        =   17
      Top             =   600
      Width           =   495
   End
   Begin Label LblHG 
      Caption         =   "840"
      Height          =   255
      Left            =   0
      TabIndex        =   16
      Top             =   1080
      Width           =   495
   End
   Begin Label LblF 
      Caption         =   "778"
      Height          =   255
      Left            =   0
      TabIndex        =   15
      Top             =   1560
      Width           =   495
   End
   Begin Label LblE 
      Caption         =   "700"
      Height          =   255
      Left            =   0
      TabIndex        =   14
      Top             =   2040
      Width           =   495
   End
   Begin Label LblD 
      Caption         =   "630"
      Height          =   255
      Left            =   0
      TabIndex        =   13
      Top             =   2520
      Width           =   495
   End
   Begin Label LblC 
      Caption         =   "583"
      Height          =   255
      Left            =   0
      TabIndex        =   12
      Top             =   3000
      Width           =   495
   End
   Begin Label LblB 
      Caption         =   "525"
      Height          =   255
      Left            =   0
      TabIndex        =   11
      Top             =   3480
      Width           =   495
   End
   Begin Label LblLA 
      Caption         =   "467"
      Height          =   255
      Left            =   0
      TabIndex        =   10
      Top             =   3960
      Width           =   495
   End
   Begin Label lblLG 
      Caption         =   "415"
      Height          =   255
      Left            =   0
      TabIndex        =   9
      Top             =   4440
      Width           =   495
   End
End
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
