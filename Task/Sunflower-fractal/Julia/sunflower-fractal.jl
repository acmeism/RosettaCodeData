using GLMakie

function sunflowerplot()
    len = 2000
    ϕ = 0.5 + sqrt(5) / 2
    r = LinRange(0.0, 100.0, len)
    θ = zeros(len)
    markersizes = zeros(Int, len)
    for i in 2:length(r)
        θ[i] = θ[i - 1] + 2π * ϕ
        markersizes[i] = div(i, 500) + 9
    end
    x = r .* cos.(θ)
    y = r .* sin.(θ)
    f = Figure()
    ax = Axis(f[1, 1], backgroundcolor = :green)
    scatter!(ax, x, y, color = :gold, markersize = markersizes, strokewidth = 1)
    hidespines!(ax)
    hidedecorations!(ax)
    return f
end

sunflowerplot()
