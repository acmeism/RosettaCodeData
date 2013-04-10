function cPoint.__add(op1, op2)  -- add the x and y components
    if type(op1)=="point" and type(op2)=="point" then
        return newPoint(
            op1:getX()+op2:getX(),
            op1:getY()+op2:getY())
    end--if type(op1)
end--cPoint.__add
function cPoint.__sub(op1, op2)  -- subtract the x and y components
    if (type(op1)=="point" and type(op2)=="point") then
        return newPoint(
            op1:getX()-op2:getX(),
            op1:getY()-op2:getY())
    end--if type(op1)
end--cPoint.__sub
