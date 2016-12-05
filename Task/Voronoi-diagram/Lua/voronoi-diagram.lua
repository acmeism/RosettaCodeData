function love.load( )
	love.math.setRandomSeed( os.time( ) ) --set the random seed
	keys = { } --an empty table where we will store key presses
	number_cells = 50 --the number of cells we want in our diagram
	--draw the voronoi diagram to a canvas
	voronoiDiagram = generateVoronoi( love.graphics.getWidth( ), love.graphics.getHeight( ), number_cells )
end

function hypot( x, y )
	return math.sqrt( x*x + y*y )
end

function generateVoronoi( width, height, num_cells )
	canvas = love.graphics.newCanvas( width, height )
	local imgx = canvas:getWidth( )
	local imgy = canvas:getHeight( )
	local nx = { }
	local ny = { }
	local nr = { }
	local ng = { }
	local nb = { }
	for a = 1, num_cells do
	table.insert( nx, love.math.random( 0, imgx ) )
	table.insert( ny, love.math.random( 0, imgy ) )
	table.insert( nr, love.math.random( 0, 255 ) )
	table.insert( ng, love.math.random( 0, 255 ) )
	table.insert( nb, love.math.random( 0, 255 ) )
	end
	love.graphics.setColor( { 255, 255, 255 } )
	love.graphics.setCanvas( canvas )
	for y = 1, imgy do
	for x = 1, imgx do
			dmin = hypot( imgx-1, imgy-1 )
		j = -1
		for i = 1, num_cells do
		d = hypot( nx[i]-x, ny[i]-y )
		if d < dmin then
	 	    dmin = d
			j = i
		end
		end
		love.graphics.setColor( { nr[j], ng[j], nb[j] } )
		love.graphics.points( x, y )
	end
	end
	--reset color
	love.graphics.setColor( { 255, 255, 255 } )
	--draw points
	for b = 1, num_cells do
	love.graphics.points( nx[b], ny[b] )
	end
	love.graphics.setCanvas( )
	return canvas
end

--RENDER
function love.draw( )
	--reset color
	love.graphics.setColor( { 255, 255, 255 } )
	--draw diagram
	love.graphics.draw( voronoiDiagram )
	--draw drop shadow text
	love.graphics.setColor( { 0, 0, 0 } )
	love.graphics.print( "space: regenerate\nesc: quit", 1, 1 )
	--draw text
	love.graphics.setColor( { 200, 200, 0 } )
	love.graphics.print( "space: regenerate\nesc: quit" )
end

--CONTROL
function love.keyreleased( key )
	if key == 'space' then
	voronoiDiagram = generateVoronoi( love.graphics.getWidth( ), love.graphics.getHeight( ), number_cells )
	elseif key == 'escape' then
	love.event.quit( )
	end
end
