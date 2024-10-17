using Images

colors = [colorant"black", colorant"red", colorant"green", colorant"darkblue",
          colorant"purple", colorant"blue", colorant"yellow", colorant"white"]
wcol = 60 # width of each color bar
h, w = 150, wcol * length(colors) + 1
img = Matrix{RGB{N0f8}}(h, w);
for (j, col) in zip(1:wcol:w, colors)
    img[:, j:j+wcol] = col
end
save("data/colourbars.jpg", img)
