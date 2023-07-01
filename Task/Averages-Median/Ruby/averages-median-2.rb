def median(aray)
    srtd = aray.sort
    alen = srtd.length
    (srtd[(alen-1)/2] + srtd[alen/2]) / 2.0
end
