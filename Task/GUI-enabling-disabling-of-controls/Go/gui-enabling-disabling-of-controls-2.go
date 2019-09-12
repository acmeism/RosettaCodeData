import gui
$include "guih.icn"

class MessageDialog : Dialog (message)
  method component_setup ()
    label := Label ("label="||message, "pos=20,20")
    add (label)
    button := TextButton("label=OK", "pos=100,60")
    button.connect (self, "dispose", ACTION_EVENT)
    add (button)

    connect (self, "dispose", CLOSE_BUTTON_EVENT)
    attrib ("size=200,100", "bg=light gray")
  end

  initially (message)
    self.Dialog.initially()
    self.message := message
end

class WindowApp : Dialog (button1, button2, field, value)
  method set_enabled ()
    if value = 0
      then field.clear_is_shaded ()
      else field.set_is_shaded ()
    if value <= 0
      then button2.set_is_shaded ()
      else button2.clear_is_shaded ()
    if value >= 10
      then button1.set_is_shaded ()
      else button1.clear_is_shaded ()
  end

  method increment ()
    value +:= 1
    field.set_contents (string(value))
    set_enabled ()
  end

  method decrement ()
    value -:= 1
    field.set_contents (string(value))
    set_enabled ()
  end

  method handle_text_field ()
    if not(integer(field.get_contents ()))
      then {
        warning := MessageDialog ("Not a number")
        warning.show_modal ()
        field.set_contents (string(value))
      }
      else {
        n := integer (field.get_contents ())
        if not (0 <= n <= 10)
          then {
            warning := MessageDialog ("Not in range")
            warning.show_modal ()
            field.set_contents (string(value))
          }
      }
    value := integer (field.get_contents ()) # must be ok
    set_enabled ()
  end

  method component_setup ()
    value := 0
    field := TextField("contents="||value, "pos=20,20", "size=150")
    field.connect (self, "handle_text_field", TEXTFIELD_CHANGED_EVENT)
    add (field)
    button1 := TextButton("label=Increment", "pos=20,60", "size=70")
    button1.connect (self, "increment", ACTION_EVENT)
    add (button1)
    button2 := TextButton("label=Decrement", "pos=100,60", "size=70")
    button2.connect (self, "decrement", ACTION_EVENT)
    add (button2)

    connect (self, "dispose", CLOSE_BUTTON_EVENT)
    attrib ("size=200,100", "bg=light gray")
    set_enabled ()
  end
end

procedure main ()
  w := WindowApp ()
  w.show_modal ()
end
