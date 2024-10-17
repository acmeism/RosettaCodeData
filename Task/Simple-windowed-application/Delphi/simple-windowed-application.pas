-- begin file --

   Program SingleWinApp ;

   // This is the equivalent of the C #include
   Uses Forms, Windows, Messages, Classes, Graphics, Controls, StdCtrls ;


   type

     // The only reason for this declaration is to allow the connection of the
     // on click method to the forms button object. This class declaration adds
     // a procedure.

     TMainForm class(tform)
       Procedure AddClicks(sender : tObject);
     end;


   // Use these globals.
   var

     MainForm : tForm ;
     aLabel   : tLabel ;
     aButton  : tButton ;
     i        : integer = 0 ;


    // This is the Method call that we connect to the button object
    // to start counting the clicks.
    Procedure tMainForm.AddClicks(sender :tObject)
    begin
      inc(i);
      aLabel.Caption := IntToStr(i) + ' Clicks since startup' ;
    end;


    Begin
      // Do all the behind the scenes stuff that sets up the Windows environment
      Application.Initialize ;

      // Create the form

      // Forms can either be created with an owner, like I have done here, or with
      // the owner set to Nil. In pascal (all versions of Borland) '''NIL''' is a
      // reserved, (the equivalent of '''NULL''' in Ansi C) word and un-sets any pointer
      // variable. Setting the owner to the application object will ensure that the form is
      // freed by the application object when the application shuts down. If I had set
      // the owner to NIL then i would have had to make sure I freed the form explicitly
      // or it would have been orphaned, thus creating a memory leak.

      // I must direct your attention to the CreateNew constructor.  This is
      // a non standard usage.  Normally the constructor Create() will call this
      // as part of the initialization routine for the form. Normally as you drop
      // various components on a form in deign mode, a DFM file is created with
      // all the various initial states of the controls. This bypasses the
      // DFM file altogether although all components AND the form are created
      // with default values. (see the Delphi help file).

      MainForm          := tMainForm.CreateNew(Application);
      MainForm.Parent   := Application ;
      MainForm.Position := poScreenCenter ;
      MainForm.Caption  := 'Single Window Application' ;

      // Create the Label, set its owner as MaiaForm
      aLabel          := tLabel.Create(mainForm);
      aLabel.Parent   := MainForm;
      aLabel.Caption  := IntToStr(i) + ' Clicks since startup' ;
      aLabel.Left     := 20 ;
      aLabel.Top      := MainForm.ClientRect.Bottom div 2 ;

      // Create the button, set its owner to MainForm
      aButton         := tButton.Create(MainForm);
      aButton.Parent  := MainForm ;
      aButton.Caption := 'Click Me!';
      aButton.Left    := (MainForm.ClientRect.Right div 2)-(aButton.Width div 2 );
      aButton.Top     := MainForm.ClientRect.Bottom - aButton.Height - 10 ;
      aButton.OnClick := AddClicks ;

      // Show the main form, Modaly. The ONLY reason to do this is because in this
      // demonstration if you only call the SHOW method, the form will appear and
      // disappear in a split second.
      MainForm.ShowModal ;

      Application.Run ;

   end. // Program
