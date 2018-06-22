import gui
$include "guih.icn"

class WindowApp : Dialog ()

  # -- automatically called when the dialog is created
  method component_setup ()
    # add 'hello world' label
    label := Label("label=Hello world","pos=0,0")
    add (label)

    # make sure we respond to close event
    connect(self, "dispose", CLOSE_BUTTON_EVENT)
  end
end

# create and show the window
procedure main ()
  w := WindowApp ()
  w.show_modal ()
end
