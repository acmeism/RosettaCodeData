using Makie, LinearAlgebra

N = 40
interval = 0.10

scene = mesh(FRect3D(Vec3f0(-0.5), Vec3f0(1)), color = :skyblue2)
rect = scene[end]

for rad in 0.5:1/N:8.5
    arr = normalize([cospi(rad/2), 0, sinpi(rad/2), -sinpi(rad/2)])
    Makie.rotate!(rect, Quaternionf0(arr[1], arr[2], arr[3], arr[4]))
    sleep(interval)
end
