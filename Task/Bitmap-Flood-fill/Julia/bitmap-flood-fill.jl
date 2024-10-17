using Images, FileIO

function floodfill!(img::Matrix{<:Color}, initnode::CartesianIndex{2}, target::Color, replace::Color)
    img[initnode] != target && return img
    # constants
    north = CartesianIndex(-1,  0)
    south = CartesianIndex( 1,  0)
    east  = CartesianIndex( 0,  1)
    west  = CartesianIndex( 0, -1)

    queue = [initnode]
    while !isempty(queue)
        node = pop!(queue)
        if img[node] == target
            wnode = node
            enode = node + east
        end
        # Move west until color of node does not match target color
        while checkbounds(Bool, img, wnode) && img[wnode] == target
            img[wnode] = replace
            if checkbounds(Bool, img, wnode + north) && img[wnode + north] == target
                push!(queue, wnode + north)
            end
            if checkbounds(Bool, img, wnode + south) && img[wnode + south] == target
                push!(queue, wnode + south)
            end
            wnode += west
        end
        # Move east until color of node does not match target color
        while checkbounds(Bool, img, enode) && img[enode] == target
            img[enode] = replace
            if checkbounds(Bool, img, enode + north) && img[enode + north] == target
                push!(queue, enode + north)
            end
            if checkbounds(Bool, img, enode + south) && img[enode + south] == target
                push!(queue, enode + south)
            end
            enode += east
        end
    end
    return img
end

img = Gray{Bool}.(load("data/unfilledcircle.png"))
floodfill!(img, CartesianIndex(100, 100), Gray(false), Gray(true))
save("data/filledcircle.png", img)
