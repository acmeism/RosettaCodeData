import Graphics.UI.Gtk
import Control.Monad

messDialog = do
  initGUI
  dialog <- messageDialogNew Nothing [] MessageInfo ButtonsOk "Goodbye, World!"

  rs <- dialogRun dialog
  when (rs == ResponseOk || rs == ResponseDeleteEvent) $ widgetDestroy dialog

  dialog `onDestroy` mainQuit

  mainGUI
