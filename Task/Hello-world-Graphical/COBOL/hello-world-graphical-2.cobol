       CLASS-ID GoodbyeWorldWPF.Window IS PARTIAL
                 INHERITS TYPE System.Windows.Window.
       METHOD-ID NEW.
       PROCEDURE DIVISION.
           INVOKE self::InitializeComponent()
       END METHOD.
       END CLASS.
