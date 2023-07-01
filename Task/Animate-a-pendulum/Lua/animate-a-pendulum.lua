function degToRad( d )
    return d * 0.01745329251
end

function love.load()
    g = love.graphics
    rodLen, gravity, velocity, acceleration = 260, 3, 0, 0
    halfWid, damp = g.getWidth() / 2, .989
    posX, posY, angle = halfWid
    TWO_PI, angle = math.pi * 2, degToRad( 90 )
end

function love.update( dt )
    acceleration = -gravity / rodLen * math.sin( angle )
    angle = angle + velocity; if angle > TWO_PI then angle = 0 end
    velocity = velocity + acceleration
    velocity = velocity * damp
    posX = halfWid + math.sin( angle ) * rodLen
    posY = math.cos( angle ) * rodLen
end

function love.draw()
    g.setColor( 250, 0, 250 )
    g.circle( "fill", halfWid, 0, 8 )
    g.line( halfWid, 4, posX, posY )
    g.setColor( 250, 100, 20 )
    g.circle( "fill", posX, posY, 20 )
end
