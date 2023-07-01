function move(n, src, via, dst)
    if n > 0 then
        move(n - 1, src, dst, via)
        print('Disk ',n,' from ' ,src, 'to', dst)
        move(n - 1, via, src, dst)

    end
end

move(4, 1, 2, 3)
