#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ###
Local $GUI = GUICreate("Clicks", 280, 50, (@DesktopWidth - 280) / 2, (@DesktopHeight - 50) / 2)
Local $lblClicks = GUICtrlCreateLabel("There have been no clicks yet", 0, 0, 278, 20, $SS_CENTER)
Local $btnClicks = GUICtrlCreateButton("CLICK ME", 104, 25, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Local $counter = 0

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $btnClicks
			$counter += 1
			GUICtrlSetData($lblClicks, "Times clicked: " & $counter)
	EndSwitch
WEnd
