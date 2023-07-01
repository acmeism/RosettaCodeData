function Allocate_Bitmap( width, height )
    local bitmap = {}
    for i = 1, width do
        bitmap[i] = {}
        for j = 1, height do
            bitmap[i][j] = {}
        end
    end
    return bitmap
end

function Fill_Bitmap( bitmap, color )
    for i = 1, #bitmap do
        for j = 1, #bitmap[1] do
            bitmap[i][j] = color
        end
    end
end

function Get_Pixel( bitmap, x, y )
    return bitmap[x][y]
end
