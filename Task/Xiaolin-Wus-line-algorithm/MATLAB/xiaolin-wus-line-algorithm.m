clear all;close all;clc;
% Example usage:
img = ones(250, 250);
img = drawline(img, 8, 8, 192, 154);
imshow(img); % Display the image

function img = drawline(img, x0, y0, x1, y1)
    function f = fpart(x)
        f = mod(x, 1);
    end

    function rf = rfpart(x)
        rf = 1 - fpart(x);
    end

    steep = abs(y1 - y0) > abs(x1 - x0);

    if steep
        [x0, y0] = deal(y0, x0);
        [x1, y1] = deal(y1, x1);
    end
    if x0 > x1
        [x0, x1] = deal(x1, x0);
        [y0, y1] = deal(y1, y0);
    end

    dx = x1 - x0;
    dy = y1 - y0;
    grad = dy / dx;

    if dx == 0
        grad = 1.0;
    end

    % handle first endpoint
    xend = round(x0);
    yend = y0 + grad * (xend - x0);
    xgap = rfpart(x0 + 0.5);
    xpxl1 = xend;
    ypxl1 = floor(yend);

    if steep
        img(ypxl1,   xpxl1) = rfpart(yend) * xgap;
        img(ypxl1+1, xpxl1) = fpart(yend) * xgap;
    else
        img(xpxl1, ypxl1  ) = rfpart(yend) * xgap;
        img(xpxl1, ypxl1+1) = fpart(yend) * xgap;
    end
    intery = yend + grad; % first y-intersection for the main loop

    % handle second endpoint
    xend = round(x1);
    yend = y1 + grad * (xend - x1);
    xgap = fpart(x1 + 0.5);
    xpxl2 = xend;
    ypxl2 = floor(yend);
    if steep
        img(ypxl2,   xpxl2) = rfpart(yend) * xgap;
        img(ypxl2+1, xpxl2) = fpart(yend) * xgap;
    else
        img(xpxl2, ypxl2  ) = rfpart(yend) * xgap;
        img(xpxl2, ypxl2+1) = fpart(yend) * xgap;
    end

    % main loop
    if steep
        for x = (xpxl1+1):(xpxl2-1)
            img(floor(intery),   x) = rfpart(intery);
            img(floor(intery)+1, x) = fpart(intery);
            intery = intery + grad;
        end
    else
        for x = (xpxl1+1):(xpxl2-1)
            img(x, floor(intery)  ) = rfpart(intery);
            img(x, floor(intery)+1) = fpart(intery);
            intery = intery + grad;
        end
    end
end
