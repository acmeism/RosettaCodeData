using Makie, FileIO, InfoZIP

if stat("newell_teaset/teapot.obj").size == 0
    download("https://www.cs.utah.edu/~natevm/newell_teaset/newell_teaset.zip", "newell_teaset.zip")
    InfoZIP.unzip("newell_teaset.zip")
end

utah_teapot = FileIO.load("newell_teaset/teapot.obj")
scene = plot(utah_teapot; color = :aquamarine, shading=true, show_axis=false)
rotate!(scene, Quaternion(0.6, 0.2, 0.2, 4.0))
display(scene)
