w_width = love.graphics.getWidth()
w_height = love.graphics.getHeight()

x = {0,1,2,3,4,5,6,7,8,9}
y = {2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0}
origin = {24,24}
points = {}
x_unit = w_width/x[10]/2
y_unit = w_height/10

--add points to an array properly formatted for the line function
for i=1,10,1 do
  table.insert(points, (x[i]*x_unit) + origin[1])
  table.insert(points, (w_height-(y[i]*2)) - origin[2])
end


function love.draw()
	
  --draw axes and grid
  love.graphics.setColor(0, 0.8, 0)
  --draw x axis
  love.graphics.line(origin[1], w_height-origin[2], w_width, w_height-origin[2])
  --draw y axis
  love.graphics.line(origin[1], w_height-origin[2], origin[1], origin[2])
  --draw grid
  for i=1,20,1 do
    love.graphics.line(origin[1], (w_height-origin[2])-(i*y_unit), w_width, (w_height-origin[2])-(i*y_unit))
    love.graphics.line(origin[1]+(i*x_unit), origin[2], origin[1]+(i*x_unit), w_height-origin[2])
  end

  --draw line plot
  love.graphics.setColor(0.8, 0, 0)
  love.graphics.line(points)
	
  --draw labels
  love.graphics.setColor(0.8, 0.8, 0.8)
  for i=0,9,1 do
    --draw x axis labels
    love.graphics.print(i, (x_unit*i) + origin[1], love.graphics.getHeight()-origin[2])
    --draw y axis labels
    love.graphics.print(i*y_unit/2, origin[1], ((love.graphics.getHeight()-i*y_unit)-origin[2]))
  end

end
