using Plots

function pointskoch(points, maxk, α = sqrt(3)/2)
  Q = [0 -1; 1 0]
  for k = 1:maxk
    n = length(points)
    new_points = Vector{Float64}[]
    for i = 1:n-1
      p1, p2 = points[i], points[i+1]
      v = (p2 - p1) / 3
      q1 = p1 + v
      q2 = p1 + 1.5v + α * Q * v
      q3 = q1 + v
      append!(new_points, [p1, q1, q2, q3])
    end
    push!(new_points, points[end])
    points = new_points
  end
  return points
end

function plot_koch(points; c=:red, kwargs...)
  n = length(points)
  plot(leg=false, axis=false, grid=false, background=:white)
  px = [p[1] for p in points]
  py = [p[2] for p in points]
  plot!(px, py, c=c; kwargs...)
end

function plot_koch!(points; c=:red, kwargs...)
  n = length(points)
  px = [p[1] for p in points]
  py = [p[2] for p in points]
  plot!(px, py, c=c; kwargs...)
end

function main()
  pyplot(size=(600,300))
  points = [[0.0; 0.0], [1.0; 0.0]]
  for k = 0:7
    new_points = pointskoch(points, k)
    plot_koch(new_points)
    ylims!(-0.1, 0.4)
    png("line-koch-$k")
  end

  pyplot(size=(200,200))
  for N = 2:8
    points = [[sin(2π*i/N), cos(2π*i/N)] for i = 0:N]
    plot_koch(points, c=:blue)
    points = pointskoch(points, 6)
    plot_koch!(points)
    xlims!(-1.5, 1.5)
    ylims!(-1.5, 1.5)
    png("polygon-$N")

    points = [[sin(2π*i/N), cos(2π*i/N)] for i = N:-1:0]
    plot_koch(points, c=:blue)
    points = pointskoch(points, 6)
    plot_koch!(points)
    xlims!(-1.5, 1.5)
    ylims!(-1.5, 1.5)
    png("polygon-reverse-$N")

    if N > 2
      points = [[sin(2π*i/N), cos(2π*i/N)] for i = N:-1:0]
      α = 0.85 / tan(π / N)
      α = 3 * sqrt(N) / 5
      points = pointskoch(points, 5, α)
      plot_koch(points)
      xlims!(-1.5, 1.5)
      ylims!(-1.5, 1.5)
      png("stargon-$N")
    end
  end

  # [1.5,  1.2,  0.96, 0.85
  # [√3/2, 1.2,  1.32, 1.47

  maxk = 5
  points = [[sin(2π*i/3), cos(2π*i/3)] for i = 3:-1:0]
  points = pointskoch(points, maxk)
  plot_koch(points)
  xlims!(-1.1, 1.1)
  ylims!(-0.9, 1.3)
  png("reverse-koch")

  N = 4
  points = [[cos(2π*i/N), sin(2π*i/N)] for i = 0:N]
  points = pointskoch(points, maxk, 1.25)
  plot_koch(points)
  png("star")

  points = [[0.0; 0.0], [1.0; 0.0], [1.0; 1.0], [0.0; 1.0], [0.0; 0.0]]
  points = pointskoch(points, maxk, 1.2)
  plot_koch(points)
  png("reverse-star")

  for N = 3:5
    points = [[cos(2π*i/N), sin(2π*i/N)] for i = 1:N]
    points = [i % 2 == 0 ? zeros(2) : points[div(i, 2) + 1] for i = 0:2N]
    points = pointskoch(points, 5, 1.0)
    plot_koch(points)
    xlims!(-1.2, 1.2)
    ylims!(-1.2, 1.2)
    png("tri-$N")
  end

  N = 3
  points = [[sin(2π*i/N), cos(2π*i/N)] for i = 0:N]
  points = pointskoch(points, maxk)
  plot_koch(points)
  α = 0.6
  plot_koch!(α^2 * points)
  plot_koch!(α^4 * points)
  points = [[y,x] for (x,y) in points]
  plot_koch!(α * points, c=:green)
  plot_koch!(α^3 * points, c=:green)
  png("koch")

  run(`montage tri-3.png koch.png tri-4.png tri-5.png reverse-star.png star.png -geometry +2+2 background.jpg`)
end

function large_koch()
  pyplot(size=(2000,2000))
  N = 3
  points = [[sin(2π*i/N), cos(2π*i/N)] for i = 0:N]
  points = pointskoch(points, 1)
  plot_koch(points)
  α = 3/sqrt(3)
  maxp = 11
  for p = 1:maxp
    points = α * [[-y;x] for (x,y) in points]
    if p < 7
      points = pointskoch(points, 1)
    end
    plot_koch!(points, c=p%2==1 ? :green : :red)
    xlims!(-1.1α^p, 1.1α^p)
    ylims!(-1.1α^p, 1.1α^p)
    png("koch-large-sub-$p")
  end
  xlims!(-1.1α^maxp, 1.1α^maxp)
  ylims!(-1.1α^maxp, 1.1α^maxp)
  png("koch-large")
end

function koch_julia()
  colors = [RGB(0.584, 0.345, 0.698)  RGB(0.667, 0.475, 0.757);
            RGB(0.220, 0.596, 0.149)  RGB(0.376, 0.678, 0.318);
            RGB(0.796, 0.235, 0.200)  RGB(0.835, 0.388, 0.361)]
  plot()
  plot_koch([])
  α = sqrt(3)/3
  for (i,θ) in enumerate([2π*i/3 for i = 0:2])
    points = [[sin(2π*i/3), cos(2π*i/3)] for i = 0:3]
    points = pointskoch(points, 6)
    plot_koch!([[sin(θ) + x; cos(θ) + y] for (x,y) in points], c=colors[i,1], lw=2)
    for p = 1:8
      points = α * [[-y; x] for (x,y) in points]
      plot_koch!([[sin(θ) + x; cos(θ) + y] for (x,y) in points], c=colors[i,p%2+1], lw=2)
    end
  end
  xlims!(-2.1, 2.1)
  ylims!(-1.9, 2.3)
  png("koch-julia")
end

#main()
#large_koch()
koch_julia()
