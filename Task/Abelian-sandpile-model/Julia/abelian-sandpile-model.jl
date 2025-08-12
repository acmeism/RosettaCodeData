""" From code by Hayk Aleksanyan, see also github.com/hayk314/Sandpiles """

""" supports output functionality for the results of the sandpile simulations
    outputs the final grid in CSV format, as well as an image file
"""
module AbelSand

using CSV, DataFrames, Images

""" given an array A trims any zero rows/columns from its borders
    returns a 4 tuple of integers, i1, i2, j1, j2, where the trimmed array corresponds to A[i1:i2, j1:j2]
    A can be either numeric or a boolean array
"""
function trimzeros(A)
    i1, j1 = 1, 1
    i2, j2 = size(A)
    zz = typeof(A[1, 1])(0)    # comparison of a value takes into account the type as well

    # i1 is the first row which has non zero element
    for i in axes(A, 1)
        q = false
        for k in axes(A, 2)
            if A[i, k] != zz
                q = true
                i1 = i
                break
            end
        end

        if q == true
            break
        end
    end

    # i2 is the first from below row with non zero element
    for i in reverse(axes(A, 1))
        q = false
        for k in axes(A, 2)
            if A[i, k] != zz
                q = true
                i2 = i
                break
            end
        end
        if q == true
            break
        end
    end

    # j1 is the first column with non zero element
    for j in axes(A, 2)
        q = false
        for k in axes(A, 1)
            if A[k, j] != zz
                j1 = j
                q = true
                break
            end
        end

        if q == true
            break
        end
    end

    # j2 is the last column with non zero element
    for j in reverse(axes(A, 2))
        q = false
        for k in axes(A, 1)
            if A[k, j] != zz
                j2 = j
                q = true
                break
            end
        end

        if q == true
            break
        end
    end

    return i1, i2, j1, j2
end

""" adds layer of zeros from all corners to the given array A """
function addlayerofzeros!(A, extraLayer)
    extraLayer <= 0 && return A

    N, M = size(A)
    Z = zeros(typeof(A[1, 1]), N + 2 * extraLayer, M + 2 * extraLayer)
    Z[(extraLayer+1):(N+extraLayer), (extraLayer+1):(M+extraLayer)] = A

    return Z
end

""" exports a 2d matrix A into a csv file, adjusting the size of the output matrix
    @extraLayer is an integers adding layer of 0-s sorrounding the output matrix
    trimming off very small values; tiny values affect the performance of CSV export
"""
function outputCSV!(A, extraLayer, strFileName, TrimSmallValues = false)
    if TrimSmallValues == true
        A = map(x -> if (abs(x - floor(x)) < 0.01)
                floor(x)
            else
                x
            end, A)
    end

    i1, i2, j1, j2 = trimzeros(A)
    A = A[i1:i2, j1:j2]
    A = addlayerofzeros!(A, extraLayer)
    CSV.write(string(strFileName, ".csv"), DataFrame(A, :auto), writeheader = false)

    return A
end

""" creates a new array A1 where each cell of the original array A appears magnified by size @cell_mag
    A is the input array; @cell_mag is the magnifying size of the cell,
    @border_mag is the magnifying size of the border between lattice cells
"""
function arraymagnifier(A, cell_mag, border_mag)
    total_factor = cell_mag + border_mag
    A1 = zeros(typeof(A[1, 1]), total_factor * size(A, 1), total_factor * size(A, 2))
    for i ∈ axes(A, 1), j ∈ axes(A, 2), u ∈ ((i-1)*total_factor+1):(i*total_factor),
        v ∈ ((j-1)*total_factor+1):(j*total_factor)

        if ((u - (i - 1) * total_factor <= cell_mag) && (v - (j - 1) * total_factor <= cell_mag))
            A1[u, v] = A[i, j]
        end
    end

    return A1
end

""" given a 2d matrix A, we save it as a gray image after magnifying by the given factors """
function savegrayimage(A, fileName, cell_mag, border_mag, TrimSmallValues = false)
    A1 = arraymagnifier(A, cell_mag, border_mag)
    A1 = A1 / maximum(maximum(A1))

    # trimming very small values from A1 to improve performance
    if TrimSmallValues == true
        A1 = map(x -> if (x < 0.01)
                0.0
            else
                round(x, digits = 2)
            end, A1)
    end

    save(string(fileName, ".png"), colorview(Gray, A1))
end

""" color_codes is a dictionary, where key is a value in A and value is an RGB triplet
    given a 2d array A, and color codes (mapping from values in A to RGB triples), save A
    into fileName as png image after applying the magnifying factors
"""
function saveRGBimage(A, fileName, color_codes, cell_mag, border_mag)
    A1 = arraymagnifier(A, cell_mag, border_mag)
    color_mat = zeros(UInt8, (3, size(A1, 1), size(A1, 2)))

    for i in axes(A1, 1)
        for j in axes(A1, 2)
            color_mat[:, i, j] = get(color_codes, A1[i, j], [0, 0, 0])
        end
    end

    save(string(fileName, ".png"), colorview(RGB, color_mat / 255))
end

const N_size = 700       # the radius of the lattice Z^2, the actual size becomes (2*N+1)x(2*N+1)
const dx = [1, 0, -1, 0] # for a given (x,y) in Z^2, (x + dx, y + dy) for all (dx,dy) covers the neighborhood of (x,y)
const dy = [0, 1, 0, -1]

""" represents a 2D lattice coordinate """
struct L_coord
    x::Int
    y::Int
end

""" Finds the (first) index of the tuple (a,b) in the given array Z of coordinates
    if no match, returns -1
"""
function findcoordinate(Z::Array{L_coord, 1}, a::Int, b::Int)
    for i ∈ 1:length(Z)
        if (Z[i].x == a) && (Z[i].y == b)
            return i
        end
    end
    return -1
end

""" Moves the pile's sand grains of size N stacked all at the origin of Z^2
    until the sandpile settled to stable configuration.
    Returns the final lattice Z_lat and the odometer Odometer
"""
function settle(N)
    Z_lat = zeros(UInt8, 2 * N_size + 1, 2 * N_size + 1)     # models the integer lattice Z^2, we will have at most 4 sands on each vertex
    V_sites = falses(2 * N_size + 1, 2 * N_size + 1)         # all sites which are visited by the sandpile process, are being marked here
    Odometer = zeros(UInt64, 2 * N_size + 1, 2 * N_size + 1) # stores the values of the odometer function

    walking = L_coord[]    # the coordinates of sites which need to move

    V_sites[N_size+1, N_size+1] = true

    # i1, ... j2  -> show the boundaries of the box which is visited by the sandpile process
    i1, i2, j1, j2 = N_size + 1, N_size + 1, N_size + 1, N_size + 1
    n = N

    t1 = time_ns()

    while n > 0
        n -= 1

        Z_lat[N_size+1, N_size+1] += 1
        if (Z_lat[N_size+1, N_size+1] >= 4)
            push!(walking, L_coord(N_size + 1, N_size + 1))
        end

        while (length(walking) > 0)
            w = pop!(walking)
            x = w.x
            y = w.y

            Z_lat[x, y] -= 4
            Odometer[x, y] += 4

            for k ∈ 1:4
                Z_lat[x+dx[k], y+dy[k]] += 1
                V_sites[x+dx[k], y+dy[k]] = true
                if Z_lat[x+dx[k], y+dy[k]] >= 4
                    if findcoordinate(walking, x + dx[k], y + dy[k]) == -1
                        push!(walking, L_coord(x + dx[k], y + dy[k]))
                    end
                end
            end

            i1 = min(i1, x - 1)
            i2 = max(i2, x + 1)
            j1 = min(j1, y - 1)
            j2 = max(j2, y + 1)
        end


    end # of the outer while
    t2 = time_ns()

    println("The final boundaries are:: ", (i2 - i1 + 1), "x", (j2 - j1 + 1), "\n")
    print("time elapsed: ", (t2 - t1) / 1.0e9, "\n")

    Z_lat = outputCSV!(Z_lat, 0, string("Abel_Z_", N))
    Odometer = outputCSV!(Odometer, 1, string("Abel_OD_", N))

    savegrayimage(Z_lat, string("Abel_Z_", N), 20, 0)
    color_code = Dict(1 => [255, 128, 255], 2 => [255, 0, 0], 3 => [0, 128, 255])
    saveRGBimage(Z_lat, string("Abel_Z_color_", N), color_code, 20, 0)

    return Z_lat, Odometer
end

end # of the module

using .AbelSand

Z_lat, Odometer = AbelSand.settle(100000)
