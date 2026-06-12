using Images, FileIO, Interpolations

function enlarge(A::Matrix, factor::AbstractFloat)
    lx, ly = size(A)
    nx, ny = round.(Int, factor .* (lx, ly))
    vx, vy = LinRange(1, lx, nx), LinRange(1, ly, ny)
    itp = interpolate(A, BSpline(Linear()))
    return itp(vx, vy)
end

A = load("data/lenna100.jpg") |> Matrix{RGB{Float64}};
Alarge = enlarge(A, 1.6);
save("data/lennaenlarged.jpg", Alarge)
