function makeTree(v,ac)
    if type(ac) == "table" then
        return {value=v,children=ac}
    else
        return {value=v}
    end
end

function printTree(t,last,prefix)
    if last == nil then
        printTree(t, false, '')
    else
        local current = ''
        local next = ''

        if last then
            current = prefix .. '\\-' .. t.value
            next = prefix .. '  '
        else
            current = prefix .. '|-' .. t.value
            next = prefix .. '| '
        end

        print(current:sub(3))
        if t.children ~= nil then
            for k,v in pairs(t.children) do
                printTree(v, k == #t.children, next)
            end
        end
    end
end

printTree(
    makeTree('A', {
        makeTree('B0', {
            makeTree('C1'),
            makeTree('C2', {
                makeTree('D', {
                    makeTree('E1'),
                    makeTree('E2'),
                    makeTree('E3')
                })
            }),
            makeTree('C3', {
                makeTree('F1'),
                makeTree('F2'),
                makeTree('F3', {makeTree('G')}),
                makeTree('F4', {
                    makeTree('H1'),
                    makeTree('H2')
                })
            })
        }),
        makeTree('B1',{
            makeTree('K1'),
            makeTree('K2', {
                makeTree('L1', {makeTree('M')}),
                makeTree('L2'),
                makeTree('L3')
            }),
            makeTree('K3')
        })
    })
)
