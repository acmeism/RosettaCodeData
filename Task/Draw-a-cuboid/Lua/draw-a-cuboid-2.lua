--
bitmap:init(40,40)
cube:scale(2,3,4)
cube:rotate(-pi/4, -pi/6)
cube:translate(0,0,10)
bitmap:clear("··")
renderer:render(cube, camera, bitmap)
screen:clear()
bitmap:render()
