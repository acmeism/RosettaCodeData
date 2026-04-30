#include <GUIConstantsEx.au3>

$hGUI = GUICreate("Hello World") ; Create the main GUI
GUICtrlCreateLabel("Goodbye, World!", -1, -1) ; Create a label dispalying "Goodbye, World!"

GUISetState() ; Make the GUI visible

While 1 ; Infinite GUI loop
	$nMsg = GUIGetMsg() ; Get any messages from the GUI
	Switch $nMsg ; Switch for a certain event
		Case $GUI_EVENT_CLOSE ; When an user closes the windows
			Exit ; Exit

	EndSwitch
WEnd
