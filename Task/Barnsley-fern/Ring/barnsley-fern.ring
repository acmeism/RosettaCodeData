Load "guilib.ring"

/*
 +---------------------------------------------------------------------------
 +        Program Name : Draw Barnsley Fern
 +        Purpose      : Draw Fern using Quadratic Equation and Random Number
 +---------------------------------------------------------------------------
*/

###-------------------------------
### DRAW CHART  size 400 x 500
###-------------------------------


New qapp {
	win1 = new qwidget() {
			### Position and Size on Screen
			setwindowtitle("Drawing using QPainter")
			setgeometry( 10, 25, 400, 500)

			### Draw within this Win Box
			label1 = new qlabel(win1) {
					### Label Position and Size
					setgeometry(10, 10, 400, 500)
					settext(" ")
			}

			buttonFern = new qpushbutton(win1) {
					### Button DrawFern
					setgeometry(10, 10, 80, 20)
					settext("Draw Fern")
					setclickevent("DrawFern()")     ### Call DRAW function
			}

			show()
	}
	exec()
}

###------------------------
### FUNCTIONS
###------------------------

Func DrawFern
		p1 = new qpicture()
		
		colorGreen = new qcolor() { setrgb(0,255,0,255) }
		penGreen   = new qpen()   { setcolor(colorGreen)    setwidth(1) }
				
		new qpainter() {
			begin(p1)
			setpen(penGreen)
															
				###-------------------------------------
				### Quadratic equation matrix of arrays
				
				a = [ 0,    0.85,  0.2,  -0.15 ]
				b = [ 0,    0.04, -0.26,  0.28 ]
				c = [ 0,   -0.04,  0.23,  0.26 ]
				d = [ 0.16, 0.85,  0.22,  0.24 ]
				e = [ 0,    0,     0,     0    ]
				f = [ 0,    1.6,   1.6,   0.44 ]

				### Initialize x, y points
				
				xf = 0.0
				yf = 0.0

				### Size of output screen
				
				MaxX = 400
				MaxY = 500
				MaxIterations = MaxY * 200
				Count = 0

				###------------------------------------------------
				
				while ( Count <= MaxIterations )
				
					### NOTE *** RING *** starts at Index 1,
					### Do NOT use Random K=0 result
					
					k = random() % 100
					k = k +1
					
					### if  (k = 0)                  k = 1  ok   ### Do NOT use
					
						if ((k > 0)  and (k <= 85))  k = 2  ok
						if ((k > 85) and (k <= 92))  k = 3  ok
						if  (k > 92)                 k = 4  ok
						
					TempX = ( a[k] * xf ) + ( b[k] * yf ) + e[k]
					TempY = ( c[k] * xf ) + ( d[k] * yf ) + f[k]

					xf = TempX
					yf = TempY

					if( (Count >= MaxIterations) or (Count != 0) )
						xPoint = (floor(xf *  MaxY / 11) + floor(MaxX / 2))
						yPoint = (floor(yf * -MaxY / 11) + MaxY )
						drawpoint( xPoint , yPoint  )
					ok
					
					Count++
				end

				###----------------------------------------------------
				
			endpaint()
		}
		
		label1 { setpicture(p1) show() }
return
