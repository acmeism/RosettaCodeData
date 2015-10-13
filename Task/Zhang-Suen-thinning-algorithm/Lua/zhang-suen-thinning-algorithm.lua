function zhangSuenThin(img)
    local dirs={
        { 0,-1},
        { 1,-1},
        { 1, 0},
        { 1, 1},
        { 0, 1},
        {-1, 1},
        {-1, 0},
        {-1,-1},
        { 0,-1},
    }

    local black=1
    local white=0

    function A(x, y)
        local c=0
        local current=img[y+dirs[1][2]][x+dirs[1][1]]
        for i=2,#dirs do
            local to_compare=img[y+dirs[i][2]][x+dirs[i][1]]
            if current==white and to_compare==black then
                c=c+1
            end
            current=to_compare
        end
        return c
    end

    function B(x, y)
        local c=0
        for i=2,#dirs do
            local value=img[y+dirs[i][2]][x+dirs[i][1]]
            if value==black then
                c=c+1
            end
        end
        return c
    end

    function common_step(x, y)
        if img[y][x]~=black or x<=1 or x>=#img[y] or y<=1 or y>=#img then
            return false
        end

        local b_value=B(x, y)
        if b_value<2 or b_value>6 then
            return false
        end

        local a_value=A(x, y)
        if a_value~=1 then
            return false
        end
        return true
    end

    function step_one(x, y)
        if not common_step(x, y) then
            return false
        end
        local p2=img[y+dirs[1][2]][x+dirs[1][1]]
        local p4=img[y+dirs[3][2]][x+dirs[3][1]]
        local p6=img[y+dirs[5][2]][x+dirs[5][1]]
        local p8=img[y+dirs[7][2]][x+dirs[7][1]]

        if p4==white or p6==white or p2==white and p8==white then
            return true
        end
        return false
    end

    function step_two(x, y)
        if not common_step(x, y) then
            return false
        end
        local p2=img[y+dirs[1][2]][x+dirs[1][1]]
        local p4=img[y+dirs[3][2]][x+dirs[3][1]]
        local p6=img[y+dirs[5][2]][x+dirs[5][1]]
        local p8=img[y+dirs[7][2]][x+dirs[7][1]]

        if p2==white or p8==white or p4==white and p6==white then
            return true
        end
        return false
    end

    function convert(to_do)
        for k,v in pairs(to_do) do
            img[v[2]][v[1]]=white
        end
    end

    function do_step_on_all(step)
        local to_convert={}
        for y=1,#img do
            for x=1,#img[y] do
                if step(x, y) then
                    table.insert(to_convert, {x,y})
                end
            end
        end
        convert(to_convert)
        return #to_convert>0
    end

    local continue=true
    while continue do
        continue=false
        if do_step_on_all(step_one) then
            continue=true
        end

        if do_step_on_all(step_two) then
            continue=true
        end
    end

    for y=1,#img do
        for x=1,#img[y] do
            io.write(img[y][x]==black and '#' or ' ')
        end
        io.write('\n')
    end
end

local image = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0},
    {0,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,0},
    {0,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,0},
    {0,1,1,1,0,0,1,1,1,1,0,0,1,1,1,0,1,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0},
    {0,1,1,1,0,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
}

zhangSuenThin(image)
