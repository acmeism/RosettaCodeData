(load "@lib/openGl.l")

(glutInit)
(glutCreateWindow "Goodbye, World!")
(keyboardFunc '(() (bye)))
(glutMainLoop)
