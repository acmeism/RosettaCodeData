using FFTW, DSP

const h1 = [-8, 2, -9, -2, 9, -8, -2]
const f1 = [ 6, -9, -7, -5]
const g1 = [-48, 84, -16, 95, 125, -70, 7, 29, 54, 10]

const h2nested = [
      [-8, 1, -7, -2, -9, 4],
      [4, 5, -5, 2, 7, -1],
      [-6, -3, -3, -6, 9, 5]]
const f2nested = [
      [-5, 2, -2, -6, -7],
      [9, 7, -6, 5, -7],
      [1, -1, 9, 2, -7],
      [5, 9, -9, 2, -5],
      [-8, 5, -2, 8, 5]]
const g2nested = [
      [40, -21, 53, 42, 105, 1, 87, 60, 39, -28],
      [-92, -64, 19, -167, -71, -47, 128, -109, 40, -21],
      [58, 85, -93, 37, 101, -14, 5, 37, -76, -56],
      [-90, -135, 60, -125, 68, 53, 223, 4, -36, -48],
      [78, 16, 7, -199, 156, -162, 29, 28, -103, -10],
      [-62, -89, 69, -61, 66, 193, -61, 71, -8, -30],
      [48, -6, 21, -9, -150, -22, -56, 32, 85, 25]]

const h3nested = [
      [[-6, -8, -5, 9], [-7, 9, -6, -8], [2, -7, 9, 8]],
      [[7, 4, 4, -6], [9, 9, 4, -4], [-3, 7, -2, -3]]]
const f3nested = [
      [[-9, 5, -8], [3, 5, 1]],
      [[-1, -7, 2], [-5, -6, 6]],
      [[8, 5, 8],[-2, -6, -4]]]
const g3nested = [
      [  [54, 42, 53, -42, 85, -72],
         [45, -170, 94, -36, 48, 73],
         [-39, 65, -112, -16, -78, -72],
         [6, -11, -6, 62, 49, 8]],
      [  [-57, 49, -23, 52, -135, 66],
         [-23, 127, -58, -5, -118, 64],
         [87, -16, 121, 23, -41, -12],
         [-19, 29, 35, -148, -11, 45]],
      [  [-55, -147, -146, -31, 55, 60],
         [-88, -45, -28, 46, -26, -144],
         [-12, -107, -34, 150, 249, 66],
         [11, -15, -34, 27, -78, -50]],
      [  [56, 67, 108, 4, 2, -48],
         [58, 67, 89, 32, 32, -8],
         [-42, -31, -103, -30, -23, -8],
         [6, 4, -26, -10, 26, 12]]]

function flatnested2d(a, siz)
    ret = zeros(Int, prod(siz))
    for i in 1:length(a), j in 1:length(a[1])
        ret[siz[2] * (i - 1) + j] = a[i][j]
    end
    Float64.(ret)
end

function flatnested3d(a, siz)
    ret = zeros(Int, prod(siz))
    for i in 1:length(a), j in 1:length(a[1]), k in 1:length(a[1][1])
        ret[siz[2] * siz[3] * (i - 1) + siz[3] * (j - 1) + k] = a[i][j][k]
    end
    Float64.(ret)
end

topow2(siz) = map(x -> nextpow(2, x), siz)
deconv1d(f1, g1) = Int.(round.(deconv(Float64.(g1), Float64.(f1))))

function deconv2d(f2, g2, xd2)
    siz = topow2([length(g2), length(g2[1])])
    h2 = Int.(round.(real.(ifft(fft(flatnested2d(g2, siz)) ./ fft(flatnested2d(f2, siz))))))
    [[h2[siz[2] * (i - 1) + j] for j in 1:xd2[2]] for i in 1:xd2[1]]
end

function deconv3d(f3, g3, xd3)
    siz = topow2([length(g3), length(g3[1]), length(g3[1][1])])
    h3 = Int.(round.(real.(ifft(fft(flatnested3d(g3, siz)) ./ fft(flatnested3d(f3, siz))))))
    [[[h3[siz[2] * siz[3] *(i - 1) + siz[3] * (j - 1) + k] for k in 1:xd3[3]]
        for j in 1:xd3[2]] for i in 1:xd3[1]]
end

deconvn(f, g, tup=()) = length(tup) < 2 ? deconv1d(f, g) :
                       length(tup) == 2 ? deconv2d(f, g, tup) :
                       length(tup) == 3 ? deconv3d(f, g, tup) :
                       println("Array nesting > 3D not supported")

deconvn(f1, g1)  # 1D
deconvn(f2nested, g2nested, (length(h2nested), length(h2nested[1]))) # 2D
println(deconvn(f3nested, g3nested,
    (length(h3nested), length(h3nested[1]), length(h3nested[1][1])))) # 3D
