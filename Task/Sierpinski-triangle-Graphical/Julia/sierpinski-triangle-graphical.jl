using Luxor

function sierpinski(txy, levelsyet)
    nxy = zeros(6)
    if levelsyet > 0
        for i in 1:6
            pos = i < 5 ? i + 2 : i - 4
            nxy[i] = (txy[i] + txy[pos]) / 2.0
        end
        sierpinski([txy[1],txy[2],nxy[1],nxy[2],nxy[5],nxy[6]], levelsyet-1)
        sierpinski([nxy[1],nxy[2],txy[3],txy[4],nxy[3],nxy[4]], levelsyet-1)
        sierpinski([nxy[5],nxy[6],nxy[3],nxy[4],txy[5],txy[6]], levelsyet-1)
    else
        poly([Point(txy[1],txy[2]),Point(txy[3],txy[4]),Point(txy[5],txy[6])], :fill ,close=true)
    end
end

Drawing(800, 800)
sierpinski([400., 100., 700., 500., 100., 500.], 7)
finish()
preview()
