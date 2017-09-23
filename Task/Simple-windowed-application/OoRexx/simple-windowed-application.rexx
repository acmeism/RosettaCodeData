/* REXX ***************************************************************************************
* 18.06.2014 Walter Pachl shortened from Rony Flatscher's bsf4oorexx (see sourceforge) samples
* Look there for ShowCount.rxj
* bsf4oorexx lets the ooRexx program use Java classes
**********************************************************************************************/
userData=.directory~new    -- a directory which will be passed to Rexx with the event

   --  create a framed Java window, set a title text
win=.bsf~new("java.awt.Frame", "Show Count")
   -- Create a Java RexxProxy for controlling the closing of the application
rexxCloseEH =.RexxCloseAppEventHandler~new   -- Rexx event handler
   -- Create Java RexxProxy for the Rexx event handler
rpCloseEH=BsfCreateRexxProxy(rexxCloseEH,,"java.awt.event.WindowListener" )
win~addWindowListener(rpCloseEH) -- add RexxProxy event handler

   -- create a Java push button
but=.bsf~new("java.awt.Button","Press me!")
   -- Create a RexxProxy for the button Rexx event handler
rp=BsfCreateRexxProxy(.RexxShowCountEventHandler~new,userData,"java.awt.event.ActionListener")
but~addActionListener(rp)        -- add RexxProxy event handler

lab=.bsf~new("java.awt.Label")   -- create a Java label,set it to show the text centered
userData~label=lab               -- save label object for later use in event handler
lab~setAlignment(lab~center)     -- set alignment to center
lab~setText("Button was not yet pressed") -- assign initial text to the label

win ~~add("Center",lab) ~~add("South",but) -- add the label and the button to the frame
win ~~pack                       -- now calculate all widget dimensions
call enlargeWidth win,but,120    -- enlarge the width of the frame and the button

win ~~setVisible(.true) ~~toFront   -- make frame visible and move it to the front

userData~i=0                     -- set counter to 0

rexxCloseEH~waitForExit          -- wait until we are allowed to end the program

-- if Java was loaded by Rexx,then terminate Java's RexxEngine to inhibit callbacks from Java
call BSF.terminateRexxEngine

::requires BSF.CLS      -- get Java support

   /* enlarge the width of the frame and of the button without using a layout manager  */
::routine enlargeWidth
  use arg win,but,addToWidth
  winDim=win~getSize            -- get frame's dimension
  winDim~width+=addToWidth      -- increase width
  win~setSize(winDim)           -- set frame's dimension

/* ------------------------------------------------------------------------ */
/* Rexx event handler to set "close app" indicator */
::class RexxCloseAppEventHandler
::method init                   -- constructor
  expose closeApp
  closeApp  = .false            -- if set to .true, then it is safe to close the app

::attribute closeApp            -- indicates whether app should be closed

::method unknown                -- intercept unhandled events,do nothing

::method windowClosing          -- event method (from WindowListener)
  expose closeApp
  closeApp=.true                -- indicate that the app should close

::method waitForExit            -- method blocks until attribute is set to .true
  expose closeApp
  guard on when closeApp=.true

/* ------------------------------------------------------------------------ */
/* Rexx event handler to process tab changes */
::class RexxShowCountEventHandler
::method actionPerformed
  use arg eventObject,slotDir
  call showCount slotDir~userData

/* ------------------------------------------------------------------------ */
::routine ShowCount             -- increment counter and show text
   use arg userData
   userData~i+=1                -- increment counter in directory object
   Select                       -- construct text part
     When userData~i=1 Then how_often='once'
     When userData~i=2 Then how_often='twice'
     When userData~i=3 Then how_often='three times'
     Otherwise how_often=userData~i 'times'
   End
   userData~label~setText("Button was pressed" how_often) -- display text
