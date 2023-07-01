Import mojo

Function Main ()
	New NintyNineBottles
End


Class NintyNineBottles Extends App

	Field _bottles:Int = 99
	Field _y:Int=640
	Field tic:Int
	Field duration:Int = 1500
	Field lyric:Int = 1
	Method OnCreate ()
		SetUpdateRate 60
	End

	  ' Stuff to do while running...
	Method OnUpdate ()
		If Millisecs()-Self.tic > Self.duration
			Self.tic=Millisecs()
			If Self.lyric= 4 Then Self._bottles-=1
			Self.lyric+=1
			
			
		End If
	End

	  ' Drawing code...

	Method OnRender ()
		Cls
				
		Select Self.lyric
			Case 1
				DrawText(_bottles+" bottles of beer on the wall",10,10)
			Case 2
				DrawText(_bottles+" bottles of beer",10,10)
			Case 3
				If Self._bottles > 1
					DrawText("take one down",10,10)
				Else
					DrawText("take it down",10,10)
				End If
			Case 4
				DrawText("Pass it around",10,10)
			Case 5
				If Self._bottles>0
					DrawText(Self._bottles+" bottles of beer on the wall",10,10)
				Else
					DrawText("no more bottles of beer on the wall",10,10)
				End If
			Case 6
				If Self._bottles>0
					Self.lyric=1'DrawText(Self._bottles+" bottles of beer on the wall",10,10)
				Else
					DrawText("no more bottles of beer",10,10)
				End if				
			Case 7
				DrawText("go to the store",10,10)
				
			Case 8
				DrawText("and buy some more",10,10)
			Case 9
				Self._bottles=99
				DrawText(_bottles+" more bottles of beer on the wall",10,10)			
			Case 10
				Self.lyric=1			
		End Select

	End

	
End
