       CLASS-ID ProgramClass.
       METHOD-ID Main STATIC.
       PROCEDURE DIVISION.
           INVOKE TYPE Application::EnableVisualStyles() *> Optional
           INVOKE TYPE MessageBox::Show("Goodbye, World!")
       END METHOD.
       END CLASS.
