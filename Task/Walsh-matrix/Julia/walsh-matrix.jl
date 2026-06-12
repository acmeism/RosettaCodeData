julia>using Plots

const w2 = [1 1; 1 -1]
walsh(k) = k < 2 ? w2 : kron(w2, walsh(k - 1))
countsignchanges(r) = count(i -> sign(r[i-1]) != sign(r[i[]]), 2:lastindex(r))
sequency(m) = sortslices(m, dims = 1, by = countsignchanges)

display(walsh(2))
display(walsh(3))
display(walsh(4))
display(sequency(walsh(3)))
display(sequency(walsh(4)))

subplots = [
    heatmap(
        (i ? sequency : identity)(walsh(n)),
        ylims = [0, 2^n + 1],
        xlims = [0, 2^n + 1],
        aspect_ratio = :equal,
        legend = false,
        axis = false,
        colormap = [:red, :forestgreen],
        yflip = true,
    ) for i = false:true, n = 3:5
]
plot(
    subplots...,
    plot_title = "Walsh, Natural Order" * "\u2007"^20 * "Walsh, Sequency Order",
    plot_titlefont = (9, "times"),
    layout = @layout [a b; c d; e f]
)
