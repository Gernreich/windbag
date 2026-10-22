VERSION 2.00
Begin Form Form1 
   Caption         =   "Win(d)bag"
   ClientHeight    =   6525
   ClientLeft      =   2550
   ClientTop       =   420
   ClientWidth     =   4680
   Height          =   6930
   Icon            =   WINDBAG.FRX:0000
   Left            =   2490
   LinkTopic       =   "Form1"
   Picture         =   WINDBAG.FRX:0302
   ScaleHeight     =   6525
   ScaleWidth      =   4680
   Top             =   75
   Width           =   4800
   Begin CommonDialog CMDialog2 
      Left            =   1320
      Top             =   2280
   End
   Begin SSCommand Label6 
      Height          =   375
      Left            =   720
      TabIndex        =   10
      Top             =   6000
      Width           =   3255
   End
   Begin SSCommand Command3D7 
      Caption         =   "Current Tune:"
      Height          =   255
      Left            =   1440
      TabIndex        =   11
      Top             =   5760
      Width           =   1935
   End
   Begin SSCommand Cmd3dPchanterComputer 
      Height          =   735
      Left            =   1440
      Picture         =   WINDBAG.FRX:21A9C
      TabIndex        =   20
      Top             =   5040
      Width           =   1455
   End
   Begin SSCommand Command3D5 
      Height          =   735
      Left            =   2880
      Picture         =   WINDBAG.FRX:22244
      TabIndex        =   19
      Top             =   5040
      Width           =   495
   End
   Begin SSCommand Command3D4 
      Height          =   495
      Left            =   2400
      Picture         =   WINDBAG.FRX:2288E
      TabIndex        =   17
      Top             =   4560
      Width           =   495
   End
   Begin SSCommand Command3D3 
      Height          =   495
      Left            =   2880
      Picture         =   WINDBAG.FRX:22ED8
      TabIndex        =   16
      Top             =   4560
      Width           =   495
   End
   Begin SSCommand Command3D2 
      Height          =   495
      Left            =   1920
      Picture         =   WINDBAG.FRX:23522
      TabIndex        =   15
      Top             =   4560
      Width           =   495
   End
   Begin SSCommand Command3D1 
      Height          =   495
      Left            =   1440
      Picture         =   WINDBAG.FRX:23B6C
      TabIndex        =   14
      Top             =   4560
      Width           =   495
   End
   Begin CommonDialog CMDialog1 
      Left            =   1800
      Top             =   2280
   End
   Begin HScrollBar hsbGrace 
      Height          =   255
      LargeChange     =   10
      Left            =   720
      TabIndex        =   3
      Top             =   840
      Value           =   12345
      Width           =   3255
   End
   Begin HScrollBar hsbMelody 
      Height          =   255
      LargeChange     =   10
      Left            =   720
      TabIndex        =   0
      Top             =   360
      Value           =   1234
      Width           =   3255
   End
   Begin Label LblPlayState 
      Height          =   495
      Left            =   120
      TabIndex        =   18
      Top             =   2280
      Visible         =   0   'False
      Width           =   1215
   End
   Begin Label Label9 
      Caption         =   "Label9"
      Height          =   495
      Left            =   120
      TabIndex        =   13
      Top             =   1320
      Visible         =   0   'False
      Width           =   3015
   End
   Begin Label Label8 
      Caption         =   "Label8"
      Height          =   495
      Left            =   120
      TabIndex        =   12
      Top             =   1800
      Visible         =   0   'False
      Width           =   3015
   End
   Begin Label melodyspeed 
      BackStyle       =   0  'Transparent
      Caption         =   "5000"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   2640
      TabIndex        =   9
      Top             =   120
      Width           =   735
   End
   Begin Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Melody"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   1200
      TabIndex        =   8
      Top             =   120
      Width           =   735
   End
   Begin Label GraceSpeed 
      BackStyle       =   0  'Transparent
      Caption         =   "15000"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   2640
      TabIndex        =   7
      Top             =   600
      Width           =   735
   End
   Begin Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Gracenotes"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   960
      TabIndex        =   6
      Top             =   600
      Width           =   1095
   End
   Begin Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Faster"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   840
      Width           =   615
   End
   Begin Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Slower"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   3960
      TabIndex        =   4
      Top             =   840
      Width           =   615
   End
   Begin Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Slower"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   3960
      TabIndex        =   2
      Top             =   360
      Width           =   615
   End
   Begin Label fasterlbl 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "Faster"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   360
      Width           =   615
   End
End
' WINDBAG.FRM
Option Explicit
Const c0024 = 4096& ' &H1000&
Const c0028 = 4& ' &H4&
Const c002C = 2048& ' &H800&
Const c0030 = 1 ' &H1%

Sub Cmd3dPchanterComputer_Click ()
pchanter.Show 1
End Sub

Sub Command2_Click ()
End Sub

Sub Command3D1_Click ()
Dim l0036 As Integer
Dim l003E As Variant
Dim l0042 As Variant
Dim l0046 As Variant
Dim l004A As Variant
Dim l004E As Variant
Dim l0052 As Variant
Dim l0056 As Variant
Dim l005A As Variant
Dim l005E As Variant
Dim l0062 As Variant
Dim l0066 As Variant
Dim l006A As Variant
Dim l006E As Integer
Dim l0070 As Variant
Dim l0074 As Variant
Dim l0078 As Variant
Dim l0082 As Variant
Dim l008C As Variant
Dim l0090 As Variant
Form1.LblPlayState.Caption = "0"
Form1.Command3D1.Picture = LoadPicture(Form1.Label8.Caption + "\playgry.bmp")
Form1.Command3D1.Enabled = False
Form1.Command3D4.Enabled = False
Form1.Command3D4.Picture = LoadPicture(Form1.Label8.Caption + "\contgry.bmp")
Form1.Command3D2.Enabled = True
Form1.Command3D2.Picture = LoadPicture(Form1.Label8.Caption + "\pauseblk.bmp")
Form1.Command3D3.Enabled = True
Form1.Command3D3.Picture = LoadPicture(Form1.Label8.Caption + "\stopblk.bmp")
Form1.Command3D7.Enabled = False
Form1.Label6.Enabled = False
Form1.Command3D5.Enabled = False
Form1.Command3D5.Picture = LoadPicture(Form1.Label8.Caption + "\quesgry.bmp")
Form1.Cmd3dPchanterComputer.Enabled = False
Form1.Cmd3dPchanterComputer.Picture = LoadPicture(Form1.Label8.Caption + "\cmpchgry.bmp")
DoEvents
l0036% = FreeFile
Open Label6.Caption For Input As #l0036%
l003E = FreeFile
Open Form1.Label8.Caption + "\chanter.txt" For Input As l003E
Input #l003E, l0042, l0046, l004A, l004E, l0052, l0056, l005A, l005E, l0062
Close l003E
l0066 = FreeFile
Open Form1.Label8.Caption + "\melgrace.txt" For Output As #l0066
l006A = 0
l006E% = FreeFile
Open Form1.Label8.Caption + "\4_4.txt" For Input As #l006E%
Do
Input #l006E%, l0070, l0074
If l0070 = "G" Then
:
l0078 = l005E
:
ElseIf l0070 = "z" Then
:
l0078 = 32767
:
End If
If l0074 = 0 Then
:
l0082 = hsbGrace.Value * 2
l006A = l006A + (hsbGrace.Value * 2)
:
Else
:
l0082 = (l0074 * hsbMelody.Value) - l006A
l006A = 0
:
End If
Call extsub170(l0078)
For l008C = 1 To l0082
Next l008C
Call extsub1A8
DoEvents
LE9A: If Form1.LblPlayState.Caption = "1" Then
:
DoEvents
GoTo LE9A
:
End If
DoEvents
Loop Until Form1.LblPlayState.Caption = "2" Or EOF(l006E%)
Close l006E%
Do
Input #l0036%, l0070, l0074
If l0070 = "g" Then
:
l0078 = l0042
:
ElseIf l0070 = "a" Then
:
l0078 = l0046
:
ElseIf l0070 = "b" Then
:
l0078 = l004A
:
ElseIf l0070 = "c" Then
:
l0078 = l004E
:
ElseIf l0070 = "d" Then
:
l0078 = l0052
:
ElseIf l0070 = "e" Then
:
l0078 = l0056
:
ElseIf l0070 = "f" Then
:
l0078 = l005A
:
ElseIf l0070 = "G" Then
:
l0078 = l005E
:
ElseIf l0070 = "A" Then
:
l0078 = l0062
:
End If
If l0074 = 0 Then
:
l0082 = hsbGrace.Value * 2
l006A = l006A + (hsbGrace.Value * 2)
:
Else
:
l0082 = (l0074 * hsbMelody.Value) - l006A
l006A = 0
:
End If
Call extsub170(l0078)
For l008C = 1 To l0082
Next l008C
Call extsub1A8
DoEvents
L1188: If Form1.LblPlayState.Caption = "1" Then
:
DoEvents
GoTo L1188
:
End If
DoEvents
Loop Until Form1.LblPlayState.Caption = "2" Or EOF(l0036%)
Form1.LblPlayState.Caption = "2"
Form1.Command3D3.Enabled = False
Form1.Command3D3.Picture = LoadPicture(Form1.Label8.Caption + "\stopgry.bmp")
Form1.Command3D1.Enabled = True
Form1.Command3D1.Picture = LoadPicture(Form1.Label8.Caption + "\playblk.bmp")
Form1.Command3D2.Enabled = False
Form1.Command3D2.Picture = LoadPicture(Form1.Label8.Caption + "\pausegry.bmp")
Form1.Command3D4.Enabled = False
Form1.Command3D4.Picture = LoadPicture(Form1.Label8.Caption + "\contgry.bmp")
Form1.Command3D5.Enabled = True
Form1.Command3D5.Picture = LoadPicture(Form1.Label8.Caption + "\quesblk.bmp")
Form1.Cmd3dPchanterComputer.Enabled = True
Form1.Cmd3dPchanterComputer.Picture = LoadPicture(Form1.Label8.Caption + "\compchnt.bmp")
Form1.Command3D7.Enabled = True
Form1.Label6.Enabled = True
Close l0036%
Print #l0066, Form1.hsbMelody.Value, Form1.hsbGrace.Value
Close l0066
l0090 = FreeFile
Open Form1.Label8.Caption + "\wbgtune.txt" For Output As #l0090
Write #l0090, Form1.Label6.Caption
Close l0090
End Sub

Sub Command3D2_Click ()
Form1.Command3D4.Enabled = True
Form1.Command3D4.Picture = LoadPicture(Form1.Label8.Caption + "\contblk.bmp")
Form1.Command3D2.Enabled = False
Form1.Command3D2.Picture = LoadPicture(Form1.Label8.Caption + "\pausegry.bmp")
Form1.Command3D3.Enabled = False
Form1.Command3D3.Picture = LoadPicture(Form1.Label8.Caption + "\stopgry.bmp")
Form1.LblPlayState.Caption = "1"
End Sub

Sub Command3D3_Click ()
Form1.LblPlayState.Caption = "2"
Form1.Command3D3.Enabled = False
Form1.Command3D3.Picture = LoadPicture(Form1.Label8.Caption + "\stopgry.bmp")
Form1.Command3D1.Enabled = True
Form1.Command3D1.Picture = LoadPicture(Form1.Label8.Caption + "\playblk.bmp")
Form1.Command3D2.Enabled = False
Form1.Command3D2.Picture = LoadPicture(Form1.Label8.Caption + "\pausegry.bmp")
Form1.Command3D4.Enabled = False
Form1.Command3D4.Picture = LoadPicture(Form1.Label8.Caption + "\contgry.bmp")
Form1.Command3D7.Enabled = True
Form1.Label6.Enabled = True
Form1.Command3D5.Enabled = True
Form1.Command3D5.Picture = LoadPicture(Form1.Label8.Caption + "\quesblk.bmp")
Form1.Cmd3dPchanterComputer.Enabled = True
Form1.Cmd3dPchanterComputer.Picture = LoadPicture(Form1.Label8.Caption + "\compchnt.bmp")
End Sub

Sub Command3D4_Click ()
Form1.LblPlayState.Caption = "3"
Form1.Command3D4.Enabled = False
Form1.Command3D4.Picture = LoadPicture(Form1.Label8.Caption + "\contgry.bmp")
Form1.Command3D1.Enabled = False
Form1.Command3D1.Picture = LoadPicture(Form1.Label8.Caption + "\playgry.bmp")
Form1.Command3D2.Enabled = True
Form1.Command3D2.Picture = LoadPicture(Form1.Label8.Caption + "\pauseblk.bmp")
Form1.Command3D3.Enabled = True
Form1.Command3D3.Picture = LoadPicture(Form1.Label8.Caption + "\stopblk.bmp")
End Sub

Sub Command3D5_Click ()
frminfo.Show 1
End Sub

Sub Command3D7_Click ()
CMDialog1.DefaultExt = "*.wbg"
CMDialog1.DialogTitle = "Tune Selection"
CMDialog1.Filter = "Windbag|*.wbg|allfiles|*.*"
CMDialog1.FilterIndex = 1
CMDialog1.Flags = c0024 Or c0028 Or c002C
CMDialog1.Action = c0030
Form1.Label6.Caption = CMDialog1.Filename
End Sub

Sub Form_Load ()
Dim l0098 As Variant
Dim l009C As Variant
Dim l00A0 As String
Dim l00A2 As Variant
Dim l00A6 As String
Dim l00A8 As Variant
Dim l00AC As Variant
Dim l00B0 As Variant
Dim l00B4 As Variant
Form1.Label8 = CurDir$
Form1.LblPlayState.Caption = "2"
Form1.Command3D3.Enabled = False
Form1.Command3D3.Picture = LoadPicture(Form1.Label8.Caption + "\stopgry.bmp")
Form1.Command3D1.Enabled = True
Form1.Command3D1.Picture = LoadPicture(Form1.Label8.Caption + "\playblk.bmp")
Form1.Command3D2.Enabled = False
Form1.Command3D2.Picture = LoadPicture(Form1.Label8.Caption + "\pausegry.bmp")
Form1.Command3D4.Enabled = False
Form1.Command3D4.Picture = LoadPicture(Form1.Label8.Caption + "\contgry.bmp")
l0098 = FreeFile
    l009C = Form1.Label8.Caption + "\wbgtune.txt"
    l00A0$ = Dir$(l009C)
    Form1.Label9.Caption = l009C
If l00A0$ = "WBGTUNE.TXT" Then
    :
    Open l009C For Input As #l0098
    Input #l0098, l00A2
    Form1.Label6.Caption = l00A2
    Close l0098
    :
Else
    :
    l00A6$ = Dir$(Form1.Label8.Caption + "\*.wbg")
    Form1.Label6.Caption = l00A6$
    :
End If
l00A8 = Form1.Label8.Caption + "\melgrace.txt"
If FileLen(l00A8) <> 0 Then
    :
    l00AC = FreeFile
    Open "melgrace.txt" For Input As #l00AC
    Input #l00AC, l00B0, l00B4
    Form1.hsbMelody.Value = l00B0
    Form1.hsbGrace.Value = l00B4
    Close l00AC
    :
Else
    :
    Form1.hsbMelody.Value = 6000
    Form1.hsbGrace.Value = 15000
    :
End If
End Sub

Sub hsbGrace_Change ()
GraceSpeed.Caption = hsbGrace
End Sub

Sub hsbMelody_Change ()
melodyspeed.Caption = hsbMelody.Value
End Sub

Sub Label6_Click ()
CMDialog1.DefaultExt = "*.wbg"
CMDialog1.DialogTitle = "Tune Selection"
CMDialog1.Filter = "Windbag|*.wbg|allfiles|*.*"
CMDialog1.FilterIndex = 1
CMDialog1.Flags = c0024 Or c0028 Or c002C
CMDialog1.Action = c0030
Form1.Label6.Caption = CMDialog1.Filename
End Sub

Sub sub298 ()
CMDialog1.DefaultExt = "*.wbg"
CMDialog1.DialogTitle = "Tune Selection"
CMDialog1.Filter = "Windbag|*.wbg|allfiles|*.*"
CMDialog1.FilterIndex = 1
CMDialog1.Flags = c0024 Or c0028 Or c002C
CMDialog1.Action = c0030
Form1.Label6.Caption = CMDialog1.Filename
End Sub

Sub sub420 ()
CMDialog1.DefaultExt = "*.wbg"
CMDialog1.DialogTitle = "Tune Selection"
CMDialog1.Filter = "Windbag|*.wbg|allfiles|*.*"
CMDialog1.FilterIndex = 1
CMDialog1.Flags = c0024 Or c0028 Or c002C
CMDialog1.Action = c0030
Form1.Label6.Caption = CMDialog1.Filename
End Sub

Sub sub5A8 ()
End Sub

Sub sub5E0 ()
pchanter.Show 1
End Sub

Sub sub618 ()
End Sub

Sub subC50 ()
End Sub

