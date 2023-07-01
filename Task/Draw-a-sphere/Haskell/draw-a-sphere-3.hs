procedure main()
W := open("Demo", "gl", "size=400,400", "bg=black") | stop("can't open window!")
WAttrib(W, "slices=40", "rings=40", "light0=on, ambient white; diffuse gold; specular gold; position 5, 0, 0" )
Fg(W, "emission blue")
DrawSphere(W, 0, 0, -5, 1)
Event(W)
end
