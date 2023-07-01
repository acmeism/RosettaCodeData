(let Frame (java "javax.swing.JFrame" T "Window")
   (java Frame 'setExtendedState
      (java (public "javax.swing.JFrame" 'MAXIMIZED_BOTH)) )
   (java Frame 'setVisible T)
   (wait 200)
   (let Size (java (java Frame 'getContentPane) 'getSize)
      (prinl "Width: " (java (public Size 'width)))
      (prinl "Height: " (java (public Size 'height))) )
   (java Frame 'dispose) )
