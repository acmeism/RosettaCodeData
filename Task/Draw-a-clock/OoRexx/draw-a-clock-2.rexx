/* REXX ---------------------------------------------------------------
   Name: clock.rxj
   Purpose: create a graphical clock that shows the current time
            -- modelled after the Java program
               at <?http:?//rosettacode.?org/wiki/Draw_a_clock#Java>?

   Needs: - ooRexx (cf. https://sourceforge.net/projects/oorexx/ )
          - BSF4ooRexx (Rexx-Java-bridge, cf.
               https://sourceforge.net/projects/bsf4oorexx/ )
          - Java (cf. http://www.java.com )
   Created: 2014-09-04
   Author:  Rony G. Flatscher
*--------------------------------------------------------------------*/
   -- import Java classes, make them available as ooRexx classes
call bsf.import "java.awt.Color"         , "awtColor"
call bsf.import "java.awt.RenderingHints", "awtRenderingHints"
call bsf.import "java.lang.Math"         , "jMath"
call bsf.import "javax.swing.JFrame"     , "swingJFrame"
call bsf.import "javax.swing.Timer"      , "swingTimer"

rxClock=.RexxClock~new                 -- create Rexx clock object
jrxClock=BSFCreateRexxProxy(rxClock)   -- box Rexx object into a Java object (a Java RexxProxy)

   /* extend Java class JPanel, make sure 'paintComponent' method invocations will get
      forwarded to a RexxProxy object that needs to be supplied upon instantiating this
      extended Java class; this method is defined in JPanel's superclass 'javax.swing.JComponent'  */
exjClz=bsf.createProxyClass("javax.swing.JPanel", "RexxJavaClock", "javax.swing.JComponent paintComponent")
javaClock=exjClz~new(jrxClock)   -- create a Java object, supply it the Java RexxProxy that processes method invocations
javaClock~setPreferredSize(.bsf~new("java.awt.Dimension", rxClock~size, rxClock~size))
javaClock~setBackground(.awtColor~white)

   -- create a JFrame, configure it a little bit
f=.swingJFrame~new
f~defaultCloseOperation=.swingJFrame~EXIT_ON_CLOSE
f~title                ="ooRexx Clock"
f~resizable            =.false
   -- add the clock (a JPanel) to it
f~contentPane~add(javaClock, bsf.loadClass("java.awt.BorderLayout")~CENTER)
f~pack                        -- let the layout manager do its work
f~locationRelativeTo   =.nil  -- no specific location (will be centered)

   /* create Rexx object that sends repaint messages to cause the clock to be updated whenever
      the swing Timer (see below) issues the "actionPerformed" event; to release the lock when
      the 'windowClosing' event is issued    */
rxEH=.RexxEventHandler~new

   /* box Rexx object as a Java object, supply the Java object (javaClock) as user data (will be
      be made available under the entry name "userdata" in the slotDir directory, appended
      to callbacks as additional argument); declare this Java proxy object to implement
      the interfaces 'java.awt.event.ActionListener' and 'java.awt.event.WindowListener'  */
jrxEH=BSFCreateRexxProxy(rxEH, javaClock, "java.awt.event.ActionListener", "java.awt.event.WindowListener")

   /* SwingTimer will cause every second the actionPerformed() event to be issued,
      bsf.dispatch() to bypass ooRexx method resolution into .Object (has a 'start' method)  */
.swingTimer~new(1000, jrxEH)~bsf.dispatch("start")
f~addWindowListener(jrxEH)  -- this allows us to get notified when the JFrame gets closed
f~~setVisible(.true)~~toFront -- show JFrame, make sure it is in the very front

say "..." pp(.DateTime~new) "Rexx main program, now waiting until JFrame gets closed ..."
rxEH~wait      -- wait
say "..." pp(.DateTime~new) "Rexx main program, JFrame got closed."


::requires "BSF.CLS"    -- get the Java camouflaging support for ooRexx

/* This class controls the painting of the clock.  */
::class RexxClock          -- will be used for an extension of javax.swing.JPanel overriding paintComponent
::method init              -- constructor, used for initializing
  expose degrees06 degrees30 degrees90 size spacing diameter x y

  degrees06 = .JMath~toRadians(6)
  degrees30 = degrees06 * 5
  degrees90 = degrees30 * 3

  size = 550
  spacing = 20;
  diameter = size - 2 * spacing
  x = trunc(diameter / 2) + spacing
  y = trunc(diameter / 2) + spacing

::attribute size get       -- make size accessible for clients

::method paintComponent
  expose degrees06 degrees30 degrees90 size spacing diameter x y
  use arg g, slotDir
  -- call dump2 slotDir, .datetime~new "- paintComponent's slotDir:"

  jobj=slotDir~javaObject  -- as the Java object invoked paintComponent the message to the rexx object will supply that Java object
  jobj~paintComponent_forwardToSuper(g)   -- now invoke the method in the (Java) superclass first

  g~setRenderingHint(.awtRenderingHints~KEY_ANTIALIASING, .awtRenderingHints~VALUE_ANTIALIAS_ON)

  g~setColor(.awtColor~black)
  g~drawOval(spacing, spacing, diameter, diameter)
  date=.dateTime~new       -- use ooRexx' date and time

  angle = degrees90 - (degrees06 * date~seconds)
  self~drawHand(g, angle, diameter / 2 - 30, .awtColor~red)

  minsecs = (date~minutes + date~seconds / 60)
  angle = degrees90 - (degrees06 * minsecs)
  self~drawHand(g, angle, diameter / 3 + 10, .awtColor~green)

  hourmins = (date~hours + minsecs / 60)
  angle = degrees90 - (degrees30 * hourmins)
  self~drawHand(g, angle, diameter / 4 + 10, .awtColor~black)


 ::method drawHand
   expose x y
   use arg g, angle, radius, color

   x2 = trunc(x + radius * .jMath~cos(angle))
   y2 = trunc(y + radius * .jMath~sin(-angle))  -- flip y-axis
   g~setColor(color)
   g~drawLine(x, y, x2, y2)



/* The following Rexx class implements the event handlers for a java.awt.event.WindowListener to be
   able to learn when the JFrame gets closed (event "windowClosing").

   In addition it implements the java.awt.event.ActionListener for updating the clock every second
   (using a swing Timer that causes the "actionPerformed" event to be issued).
*/
::class RexxEventHandler
::method init     -- constructor for initialization
  expose wait     -- object variable to serve as a control variable
  wait=.true      -- initialize lock

::method wait     -- method to allow for blocking
  expose wait
  guard on when wait<>.true   -- the caller will be blocked until this condition turns to .false

::method windowClosing        -- Window event when window gets closed, release wait lock
  expose wait
  wait=.false     -- release lock

::method unknown  -- catch all other window-events

::method actionPerformed   -- this event will be caused every second by the swing Timer
  use arg eventObj, slotDir
  slotDir~userData~repaint -- fetch the Java object and send it the repaint message
