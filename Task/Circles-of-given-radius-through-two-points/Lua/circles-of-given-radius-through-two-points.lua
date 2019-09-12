function distance(p1, p2)
    local dx = (p1.x-p2.x)
    local dy = (p1.y-p2.y)
    return math.sqrt(dx*dx + dy*dy)
end

function findCircles(p1, p2, radius)
    local seperation = distance(p1, p2)
    if seperation == 0.0 then
        if radius == 0.0 then
            print("No circles can be drawn through ("..p1.x..", "..p1.y..")")
        else
            print("Infinitely many circles can be drawn through ("..p1.x..", "..p1.y..")")
        end
    elseif seperation == 2*radius then
        local cx = (p1.x+p2.x)/2
        local cy = (p1.y+p2.y)/2
        print("Given points are opposite ends of a diameter of the circle with center ("..cx..", "..cy..") and radius "..radius)
    elseif seperation > 2*radius then
        print("Given points are further away from each other than a diameter of a circle with radius "..radius)
    else
        local mirrorDistance = math.sqrt(math.pow(radius,2) - math.pow(seperation/2,2))
        local dx = p2.x - p1.x
        local dy = p1.y - p2.y
        local ax = (p1.x + p2.x) / 2
        local ay = (p1.y + p2.y) / 2
        local mx = mirrorDistance * dx / seperation
        local my = mirrorDistance * dy / seperation
        c1 = {x=ax+my, y=ay+mx}
        c2 = {x=ax-my, y=ay-mx}

        print("Two circles are possible.")
        print("Circle C1 with center ("..c1.x..", "..c1.y.."), radius "..radius)
        print("Circle C2 with center ("..c2.x..", "..c2.y.."), radius "..radius)
    end
    print()
end

cases = {
    {x=0.1234, y=0.9876},   {x=0.8765, y=0.2345},
    {x=0.0000, y=2.0000},   {x=0.0000, y=0.0000},
    {x=0.1234, y=0.9876},   {x=0.1234, y=0.9876},
    {x=0.1234, y=0.9876},   {x=0.8765, y=0.2345},
    {x=0.1234, y=0.9876},   {x=0.1234, y=0.9876}
}
radii = { 2.0, 1.0, 2.0, 0.5, 0.0 }
for i=1, #radii do
    print("Case "..i)
    findCircles(cases[i*2-1], cases[i*2], radii[i])
end
