﻿Type=Class
Version=4.3
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'Events declaration
#Event: ValueChanged(Value As Int, UserChanged As Boolean)

'Class module
Private Sub Class_Globals
Private dr1,dr2,dr3 As GradientDrawable
Private slider, caret As ImageView
Private Vpos, H, W, Minv,MaxV, D As Int
Private Vmodule As Object
Private Vbase,  cover As Panel
Private BarName As String
End Sub

'Initializes the object. 
'Module is the launching module, put Me.
'The object can be defined as custom view by the designer:
'Put minimim value and maximum value with separating comma in Tag.
'The Drawable will define the drawable of the background panel.
Public Sub Initialize(Module As Object, Eventname As String)
Vmodule = Module
BarName = Eventname
End Sub

'If you create the object by code, not by the designer, use this sub after initialization.
Public Sub CodeCreateView( width As Int ,height As Int,MinValue As Int, MaxValue As Int)
H = height
W = width
Minv = MinValue
MaxV = MaxValue
D =  20dip ' default caret height
Vbase.Initialize("")
ContinueCreation
End Sub

Private Sub DesignerCreateView(base As Panel, Lbl As Label, Props As Map)'ignore
base.Left = Lbl.Left
base.Top = Lbl.top
base.Width = Lbl.Width
base.Height = Lbl.Height
Vbase.Initialize("")
base.AddView(Vbase,0, 0, Lbl.Width, Lbl.Height)
H = Lbl.Height 
W = Lbl.Width
Dim str() As String = Regex.Split("," , Lbl.Tag)
Minv = str(0)
MaxV = str(1)
ContinueCreation
End Sub

Private Sub ContinueCreation
D = 20dip ' default caret height
slider.Initialize("")
Vbase.AddView(slider,0,0,W,H)
caret.Initialize("")
Vbase.AddView(caret,0,H/2-D/2,W,D)
cover.Initialize("cover")
Vbase.AddView(cover,0,0,W,H)
									' These are the default colors
setColors(Colors.Black,Colors.white, Colors.Yellow, Colors.white)
End Sub

'Sets the colors of the bar
Sub setColors(BackGround As Int,basecolor As Int,slidercolor As Int, caretcolor As Int)
Dim clr(3) As Int
clr = Array  As Int(BackGround,basecolor,BackGround) 
dr1.Initialize("LEFT_RIGHT",clr)
Vbase.BackGround =   dr1 
clr = Array  As Int(BackGround,slidercolor,BackGround) 
dr2.Initialize("LEFT_RIGHT",clr)
slider.BackGround = dr2
clr = Array  As Int(BackGround,caretcolor,BackGround) 
dr3.Initialize("TOP_BOTTOM",clr)
caret.BackGround =  dr3
End Sub

'Returns the base panel
Public Sub AsView As View 
Return Vbase
End Sub

' Sets the Min and Max values of the bar 
Public Sub setMaxandMin(MinValue As Int, MaxValue As Int)
Minv = MinValue
MaxV = MaxValue
End Sub

'Sets the height of the caret.
'The default is 20dip.
Sub setCaretHeight(value As Int)
D = value
caret.Height = D
caret.top = Max(Min(slider.top-D/2, H-D), 0) 
End Sub

Private Sub setPosition(Value As Int, userchanged As Boolean)
slider.height = Max(Min(H * (Value-Minv) / (MaxV-Minv), H ),0)
slider.Top =  H - slider.height
caret.top = Max(Min(slider.top-D/2, H-D), 0)  
Vbase.Invalidate
If SubExists(Vmodule, BarName & "_ValueChanged") Then
  CallSub3(Vmodule,BarName & "_ValueChanged", Value , userchanged )
End If
End Sub

' Sets the value of the bar 
' ValueChanged event will be raised with Userchanged = false
'This function must be performed by code at least once prior to use of the bar.
Public Sub setValue(Value As Int)
Vpos = Min(Max(Value,Minv),MaxV)
H = Vbase.Height
setPosition(Vpos,False)
End Sub

' Returns the current value of the bar
Public Sub getValue As Int
Return Vpos
End Sub


Private Sub cover_Touch(Action As Int, X As Float, Y As Float) As Boolean 
Dim k As Int
k = (1-Y/Vbase.Height)* (MaxV-Minv) + Minv
k = Max(Min(k, MaxV),Minv)
setPosition(k, True)
Return True
End Sub