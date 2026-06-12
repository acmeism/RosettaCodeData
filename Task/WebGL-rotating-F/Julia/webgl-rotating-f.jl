using Colors
using GeometryBasics: Rect3f
using GLMakie

topbar = vec([Point3f(i / 5, j / 5, k / 5) for i in 1:7, j in 8:3:28, k in 45:50])
stem = vec([Point3f(i / 5, j / 5, k / 5) for i in 1:7, j in 1:7, k in 1:8:56])
midbar = vec([Point3f(i / 5, j / 5, k / 5) for i in 1:7, j in 8:2:21, k in 25:29])
fig = Figure(resolution = (800, 400))
pos = fig[1, 1]
meshscatter(pos, topbar; marker = Rect3f(Vec3f(-0.5), Vec3f(16)), transparency = true,
   color = [RGBA(topbar[i]..., 0.5) for i in 1:length(topbar)])
meshscatter!(pos, stem; marker = Rect3f(Vec3f(-0.5), Vec3f(16)), transparency = true,
   color = [RGBA(stem[i]..., 0.5) for i in 1:length(stem)])
meshscatter!(pos, midbar; marker = Rect3f(Vec3f(-0.5), Vec3f(16)), transparency = true,
   color = [RGBA(midbar[i]..., 0.5) for i in 1:length(midbar)])

for _ in 1:28
    display(fig.scene)
    rotate!(Accum, fig.scene, 0.25)
    sleep(0.25)
end
