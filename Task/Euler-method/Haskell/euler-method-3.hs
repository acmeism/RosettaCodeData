import Graphics.EasyPlot

newton t temp = -0.07 * (temp - 20)

exactSolution t = 80*exp(-0.07*t)+20

test1 = plot (PNG "euler1.png")
  [ Data2D [Title "Step 10", Style Lines] [] sol1
  , Data2D [Title "Step 5", Style Lines] [] sol2
  , Data2D [Title "Step 1", Style Lines] [] sol3
  , Function2D [Title "exact solution"] [Range 0 100] exactSolution ]
 where sol1 = dsolveBy euler newton [0,10..100] 100
       sol2 = dsolveBy euler newton [0,5..100] 100
       sol3 = dsolveBy euler newton [0,1..100] 100

test2 = plot (PNG "euler2.png")
  [ Data2D [Title "Euler"] [] sol1
  , Data2D [Title "RK2"] [] sol2
  , Data2D [Title "RK4"] [] sol3
  , Function2D [Title "exact solution"] [Range 0 100] exactSolution ]
 where sol1 = dsolveBy euler newton [0,10..100] 100
       sol2 = dsolveBy rk2 newton [0,10..100] 100
       sol3 = dsolveBy rk4 newton [0,10..100] 100
