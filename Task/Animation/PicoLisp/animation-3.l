#!ersatz/pil

(setq
   Dir 1
   Text (chop "Hello World! ")
   Frame (java "javax.swing.JFrame" T "Animation")
   Label (java "javax.swing.JLabel" T (pack Text)) )

(java Label 'addMouseListener
   (interface "java.awt.event.MouseListener"
      'mouseClicked '((Ev) (setq Dir (if (= 1 Dir) 12 1)))
      'mouseEntered nil
      'mouseExited nil
      'mousePressed nil
      'mouseReleased nil ) )

(java Frame 'add Label)
(java Frame 'pack)
(java Frame 'setVisible T)
(loop
   (wait 200)
   (java Label 'setText (pack (do Dir (rot Text)))) )
