(for File '(a.txt b.txt c.txt)
   (call 'mv File (tmp File))
   (out File
      (in (tmp File)
         (while (echo "Goodbye London!")
            (prin "Hello New York!") ) ) ) )
