using Dates, Colors, SimpleDirectMediaLayer.LibSDL2

mutable struct ParticleFountain
    particlenum::Int
    positions::Vector{Float64}
    velocities::Vector{Float64}
    lifetimes::Vector{Float64}
    points::Vector{SDL_Point}
    numpoints::Int
    saturation::Float64
    spread::Float64
    range::Float64
    reciprocate::Bool
    ParticleFountain(N) = new(N, zeros(2N), zeros(2N), zeros(N), fill(SDL_Point(0, 0), N),
        0, 0.4, 1.5, 1.5, false)
end

function update(pf, w, h, df)
    xidx, yidx, pointidx = 1, 2, 0
    recip() = pf.reciprocate ? pf.range * sin(Dates.value(now()) / 1000) : 0.0
    for idx in 1:pf.particlenum
        willdraw = false
        if pf.lifetimes[idx] <= 0.0
            if rand() < df
                pf.lifetimes[idx]   = 2.5;                       # time to live
                pf.positions[xidx]  = (w / 20)                   # starting position x
                pf.positions[yidx]  = (h / 10)                   # and y
                pf.velocities[xidx] = 10 * (pf.spread * rand() - pf.spread / 2 + recip()) # starting velocity x
                pf.velocities[yidx] = (rand() - 2.9) * h / 20.5; # and y (randomized slightly so points reach different heights)
                willdraw = true
            end
        else
            if pf.positions[yidx] > h / 10 && pf.velocities[yidx] > 0
                pf.velocities[yidx] *= -0.3                  # "bounce"
            end
            pf.velocities[yidx] += df * h / 10                  # adjust velocity
            pf.positions[xidx]  += pf.velocities[xidx] * df     # adjust position x
            pf.positions[yidx]  += pf.velocities[yidx] * df     # and y
            pf.lifetimes[idx]  -= df
            willdraw = true
        end

        if willdraw # gather all of the points that are going to be rendered
            pointidx += 1
            pf.points[pointidx] = SDL_Point(Cint(floor(pf.positions[xidx] * 10)),
                Cint(floor(pf.positions[yidx] * 10)))
        end
        xidx += 2
        yidx = xidx + 1
        pf.numpoints = pointidx
    end
    return pf
end

function fountain(particlenum = 3000, w = 800, h = 800)
    SDL_Init(SDL_INIT_VIDEO)
    window = SDL_CreateWindow("Julia Particle System!", SDL_WINDOWPOS_CENTERED_MASK,
        SDL_WINDOWPOS_CENTERED_MASK, w, h, SDL_WINDOW_RESIZABLE)
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED)
    SDL_ClearError()
    df = 0.0001
    pf = ParticleFountain(3000)
    overallstart, close, frames = now(), false, 0
    while !close
        dfstart = now()
        event_ref = Ref{SDL_Event}()
        while Bool(SDL_PollEvent(event_ref))
            event_type = event_ref[].type
            evt = event_ref[]
            if event_type == SDL_QUIT
                close = true
                break
            end
            if event_type == SDL_WINDOWEVENT
                if evt.window.event == 5
                    w = evt.window.data1
                    h = evt.window.data2
                end
            end
            if event_type == SDL_KEYDOWN
                comm = evt.key.keysym.scancode
                if comm == SDL_SCANCODE_UP
                    saturation = min(pf.saturation + 0.1, 1.0)
                elseif comm == SDL_SCANCODE_DOWN
                    saturation = max(pf.saturation - 0.1, 0.0)
                elseif comm == SDL_SCANCODE_PAGEUP
                    spread = min(pf.spread + 1, 50.0)
                elseif comm == SDL_SCANCODE_PAGEDOWN
                    spread = max(pf.spread - 0.1, 0.2)
                elseif comm == SDL_SCANCODE_LEFT
                    range = min(pf.range + 0.1, 12.0)
                elseif comm == SDL_SCANCODE_RIGHT
                    range = max(pf.range - 0.1, 0.1)
                elseif comm == SDL_SCANCODE_SPACE
                    pf.reciprocate = !pf.reciprocate
                elseif comm == SDL_SCANCODE_Q
                    close = true
                    break
                end
            end
        end
        pf = update(pf, w, h, df)
        SDL_SetRenderDrawColor(renderer, 0x0, 0x0, 0x0, 0xff)
        SDL_RenderClear(renderer)
        rgb = parse(UInt32, hex(HSL((Dates.value(now()) % 5) * 72, pf.saturation, 0.5)), base=16)
        red, green, blue = rgb & 0xff, (rgb >> 8) & 0xff, (rgb >>16) & 0xff
        SDL_SetRenderDrawColor(renderer, red, green, blue, 0x7f)
        SDL_RenderDrawPoints(renderer, pf.points, pf.numpoints)
        SDL_RenderPresent(renderer)
        frames += 1
        df = Float64(Dates.value(now()) - Dates.value(dfstart)) / 1000
        elapsed = Float64(Dates.value(now()) - Dates.value(overallstart)) / 1000
        elapsed > 0.5 && print("\r", ' '^20, "\rFPS: ", round(frames / elapsed, digits=1))
    end
    SDL_Quit()
end

println("""
    Use UP and DOWN arrow keys to modify the saturation of the particle colors.
    Use PAGE UP and PAGE DOWN keys to modify the "spread" of the particles.
    Toggle reciprocation off / on with the SPACE bar.
    Use LEFT and RIGHT arrow keys to modify angle range for reciprocation.
    Press the "q" key to quit.
""")

fountain()
