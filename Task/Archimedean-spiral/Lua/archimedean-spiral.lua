a=1
b=2
cycles=40
step=0.001
x=0
y=0

function love.load()
     x = love.graphics.getWidth()/2
     y = love.graphics.getHeight()/2
end

function love.draw()
     love.graphics.print("a="..a,16,16)
     love.graphics.print("b="..b,16,32)

     for i=0,cycles*math.pi,step do
          love.graphics.points(x+(a + b*i)*math.cos(i),y+(a + b*i)*math.sin(i))
     end
end
