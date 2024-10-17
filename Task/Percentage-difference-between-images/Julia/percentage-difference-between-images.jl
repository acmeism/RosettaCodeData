using Images, FileIO, Printf

absdiff(a::RGB{T}, b::RGB{T}) where T = sum(abs(col(a) - col(b)) for col in (red, green, blue))
function pctdiff(A::Matrix{Color{T}}, B::Matrix{Color{T}}) where T
    size(A) != size(B) && throw(ArgumentError("images must be same-size"))
    s = zero(T)
    for (a, b) in zip(A, B)
        s += absdiff(a, b)
    end
    return 100s / 3prod(size(A))
end

img50  = load("data/lenna50.jpg") |> Matrix{RGB{Float64}};
img100 = load("data/lenna100.jpg") |> Matrix{RGB{Float64}};

d = pctdiff(img50, img100)
@printf("Percentage difference: %.4f%%\n", d)
