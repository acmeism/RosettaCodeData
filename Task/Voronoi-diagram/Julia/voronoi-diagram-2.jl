using TestImages, Images
function voronoi_img!(img, n_centroids)
    n,m = size(img)
    w   = minimum([n,m])
    dist = (point,vector) -> sqrt.((point[1].-vector[:,1]).^2 .+ (point[2].-vector[:,2]).^2)
    dots = [rand(1:n, n_centroids) rand(1:m, n_centroids)]
    c = []
    for i in 1:size(dots,1)
        p = dots[i,:]
        append!(c, [img[p[1],p[2]]])
    end
    dots = [dots c]

    for x in 1:n, y in 1:m
        distances = dist([x,y],dots) # distance
        nn = findmin(distances)[2]
        img[x,y]  = dots[nn,:][3]
    end
end
img = testimage("mandrill")
voronoi_img!(img, 300)
