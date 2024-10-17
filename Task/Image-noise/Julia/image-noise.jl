using Gtk, GtkUtilities

 function randbw(ctx, w, h)
    pic = zeros(Int64, w, h)
    for i in 1:length(pic)
        pic[i] = rand([1, 0])
    end
    copy!(ctx, pic)
end

const can = @GtkCanvas()
const win = GtkWindow(can, "Image Noise", 320, 240)

@guarded draw(can) do widget
    ctx = getgc(can)
    h = height(can)
    w = width(can)
    randbw(ctx, w, h)
end

show(can)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)

while true
    frames = 0
    t = time()
    for _ in 1:100
        draw(can)
        show(can)
        sleep(0.0001)
        frames += 1
    end
    fps = round(frames / (time() - t), digits=1)
    set_gtk_property!(win, :title, "Image Noise: $fps fps")
end

wait(cond)
