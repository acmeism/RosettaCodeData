import Graphics.UI.Gtk
import Control.Monad

main = do
  initGUI

  window <- windowNew
  set window [windowTitle := "Graphical user input", containerBorderWidth := 10]

  vb <- vBoxNew False 0
  containerAdd window vb

  hb1 <- hBoxNew False 0
  boxPackStart vb hb1 PackNatural 0
  hb2 <- hBoxNew False 0
  boxPackStart vb hb2 PackNatural 0

  lab1 <- labelNew (Just "Enter number 75000")
  boxPackStart hb1 lab1 PackNatural 0
  nrfield <- entryNew
  entrySetText nrfield "75000"
  boxPackStart hb1 nrfield PackNatural 5

  strfield <- entryNew
  boxPackEnd hb2 strfield PackNatural 5
  lab2 <- labelNew (Just "Enter a text")
  boxPackEnd hb2 lab2 PackNatural 0

  accbox    <- hBoxNew False 0
  boxPackStart vb accbox PackNatural 5
  im <- imageNewFromStock stockApply IconSizeButton
  acceptButton <- buttonNewWithLabel "Accept"
  buttonSetImage acceptButton im
  boxPackStart accbox acceptButton PackRepel 0

  txtstack <- statusbarNew
  boxPackStart vb txtstack PackNatural 0
  id <- statusbarGetContextId txtstack "Line"

  widgetShowAll window

  onEntryActivate nrfield (showStat nrfield txtstack id)
  onEntryActivate strfield (showStat strfield txtstack id)

  onPressed acceptButton $ do
    g <- entryGetText nrfield
    if g=="75000" then
      widgetDestroy window
     else do
       msgid <- statusbarPush txtstack id "You didn't enter 75000. Try again"
       return ()

  onDestroy window mainQuit
  mainGUI

showStat :: Entry -> Statusbar -> ContextId -> IO ()
showStat fld stk id = do
    txt <- entryGetText fld
    let mesg = "You entered \"" ++ txt ++ "\""
    msgid <- statusbarPush stk id mesg
    return ()
