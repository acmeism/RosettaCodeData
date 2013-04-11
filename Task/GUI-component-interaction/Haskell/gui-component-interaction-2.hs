import gui
$include "guih.icn"

# Provides a basic message dialog
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

# Provides a basic yes/no question dialog
class QuestionDialog : Dialog (answer, message)
  method answered_yes ()
    return answer == "yes"
  end

  method answer_yes ()
    answer := "yes"
    dispose ()
  end

  method answer_no ()
    answer := "no"
    dispose ()
  end

  method component_setup ()
    label := Label ("label="||message, "pos=20,20")
    add (label)
    buttonYes := TextButton("label=Yes", "pos=40,60")
    buttonYes.connect (self, "answer_yes", ACTION_EVENT)
    add (buttonYes)
    buttonNo := TextButton("label=No", "pos=120,60")
    buttonNo.connect (self, "answer_no", ACTION_EVENT)
    add (buttonNo)

    connect (self, "dispose", CLOSE_BUTTON_EVENT)
    attrib ("size=200,100", "bg=light gray")
  end

  initially (message)
    self.Dialog.initially()
    self.answer := "no"
    self.message := message
end

# The main window, displays the different components
class WindowApp : Dialog (field, value)
  method increment ()
    value +:= 1
    field.set_contents (string(value))
  end

  method random ()
    query := QuestionDialog ("Set to random?")
    query.show_modal ()
    if query.answered_yes () then {
      value := ?100
      field.set_contents (string(value))
    }
  end

  method handle_text_field ()
    if not(integer(field.get_contents ()))
      then {
        warning := MessageDialog ("Not a number")
        warning.show_modal ()
        field.set_contents (string(value))
      }
      else {
        value := integer(field.get_contents ())
      }
  end

  method component_setup ()
    value := 0
    field := TextField("contents="||value, "pos=20,20", "size=150")
    field.connect (self, "handle_text_field", TEXTFIELD_CHANGED_EVENT)
    add (field)
    button1 := TextButton("label=Increment", "pos=20,60", "size=70")
    button1.connect (self, "increment", ACTION_EVENT)
    add (button1)
    button2 := TextButton("label=Random", "pos=100,60", "size=70")
    button2.connect (self, "random", ACTION_EVENT)
    add (button2)

    connect (self, "dispose", CLOSE_BUTTON_EVENT)
    attrib ("size=200,100", "bg=light gray")
  end
end

# create and show the window
procedure main ()
  w := WindowApp ()
  w.show_modal ()
end
