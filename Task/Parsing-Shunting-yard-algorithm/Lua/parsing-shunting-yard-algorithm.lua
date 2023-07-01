-- Lua 5.3.5
-- Retrieved from: https://devforum.roblox.com/t/more-efficient-way-to-implement-shunting-yard/1328711
-- Modified slightly to ensure conformity with other code snippets posted here
local OPERATOR_PRECEDENCE = {
    -- [operator] = { [precedence], [is left assoc.] }
    ['-'] = { 2, true };
    ['+'] = { 2, true };
    ['/'] = { 3, true };
    ['*'] = { 3, true };
    ['^'] = { 4, false };
}

local function shuntingYard(expression)
    local outputQueue = { }
    local operatorStack = { }

    local number, operator, parenthesis, fcall

    while #expression > 0 do
        local nStartPos, nEndPos = string.find(expression, '(%-?%d+%.?%d*)')

        if nStartPos == 1 and nEndPos > 0 then
            number, expression = string.sub(expression, nStartPos, nEndPos), string.sub(expression, nEndPos + 1)
            table.insert(outputQueue, tonumber(number))

            print('token:', number)
            print('queue:', unpack(outputQueue))
            print('stack:', unpack(operatorStack))
        else
            local oStartPos, oEndPos = string.find(expression, '([%-%+%*/%^])')

            if oStartPos == 1 and oEndPos > 0 then
                operator, expression = string.sub(expression, oStartPos, oEndPos), string.sub(expression, oEndPos + 1)

                if #operatorStack > 0 then
                    while operatorStack[1] ~= '(' do
                        local operator1Precedence = OPERATOR_PRECEDENCE[operator]
                        local operator2Precedence = OPERATOR_PRECEDENCE[operatorStack[1]]

                        if operator2Precedence and ((operator2Precedence[1] > operator1Precedence[1]) or (operator2Precedence[1] == operator1Precedence[1] and operator1Precedence[2])) then
                            table.insert(outputQueue, table.remove(operatorStack, 1))
                        else
                           break
                        end
                    end
                end

                table.insert(operatorStack, 1, operator)

                print('token:', operator)
                print('queue:', unpack(outputQueue))
                print('stack:', unpack(operatorStack))
            else
                local pStartPos, pEndPos = string.find(expression, '[%(%)]')

                if pStartPos == 1 and pEndPos > 0 then
                    parenthesis, expression = string.sub(expression, pStartPos, pEndPos), string.sub(expression, pEndPos + 1)

                    if parenthesis == ')' then
                        while operatorStack[1] ~= '(' do
                            assert(#operatorStack > 0)
                            table.insert(outputQueue, table.remove(operatorStack, 1))
                        end

                        assert(operatorStack[1] == '(')
                        table.remove(operatorStack, 1)
                    else
                        table.insert(operatorStack, 1, parenthesis)
                    end

                    print('token:', parenthesis)
                    print('queue:', unpack(outputQueue))
                    print('stack:', unpack(operatorStack))
                else
                    local wStartPos, wEndPos = string.find(expression, '%s+')

                    if wStartPos == 1 and wEndPos > 0 then
                        expression = string.sub(expression, wEndPos + 1)
                    else
                        error('Invalid character set: '.. expression)
                    end
                end
            end
        end
    end

    while #operatorStack > 0 do
        assert(operatorStack[1] ~= '(')
        table.insert(outputQueue, table.remove(operatorStack, 1))
    end

    return table.concat(outputQueue, ' ')
end


local goodmath = '3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3'

print('infix:', goodmath)
print('postfix:', shuntingYard(goodmath))
