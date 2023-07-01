# Need some turtle graphics
(load "@lib/math.l")

(setq
   *TurtleX 100      # X position
   *TurtleY  75      # Y position
   *TurtleA 0.0 )    # Angle

(de fd (Img Len)  # Forward
   (let (R (*/ *TurtleA pi 180.0)  DX (*/ (cos R) Len 1.0)  DY (*/ (sin R) Len 1.0))
      (brez Img *TurtleX *TurtleY DX DY)
      (inc '*TurtleX DX)
      (inc '*TurtleY DY) ) )

(de rt (A)  # Right turn
   (inc '*TurtleA A) )

(de lt (A)  # Left turn
   (dec '*TurtleA A) )


# Dragon curve stuff
(de *DragonStep . 4)

(de dragon (Img Depth Dir)
   (if (=0 Depth)
      (fd Img *DragonStep)
      (rt Dir)
      (dragon Img (dec Depth) 45.0)
      (lt (* 2 Dir))
      (dragon Img (dec Depth) -45.0)
      (rt Dir) ) )

# Run it
(let Img (make (do 200 (link (need 300 0))))       # Create image 300 x 200
   (dragon Img 10 45.0)                            # Build dragon curve
   (out "img.pbm"                                  # Write to bitmap file
      (prinl "P1")
      (prinl 300 " " 200)
      (mapc prinl Img) ) )
