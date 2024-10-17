using Images
function voronoi(w, h, n_centroids)
    dist = (point,vector) -> sqrt.((point[1].-vector[:,1]).^2 .+ (point[2].-vector[:,2]).^2)
    dots = [rand(1:h, n_centroids) rand(1:w, n_centroids) rand(RGB{N0f8}, n_centroids)]
    img  = zeros(RGB{N0f8}, h, w)
    for x in 1:h, y in 1:w
        distances = dist([x,y],dots) # distance
        nn = findmin(distances)[2]
        img[x,y]  = dots[nn,:][3]
    end
    return img
end
img = voronoi(800, 600, 200)
