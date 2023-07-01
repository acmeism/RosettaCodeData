local stack = {}
function push( a ) table.insert( stack, 1, a ) end
function pop()
    if #stack == 0 then return nil end
    return table.remove( stack, 1 )
end
function writeStack()
    for i = #stack, 1, -1 do
        io.write( stack[i], " " )
    end
    print()
end
function operate( a )
    local s
    if a == "+" then
        push( pop() + pop() )
        io.write( a .. "\tadd\t" ); writeStack()
    elseif a == "-" then
        s = pop(); push( pop() - s )
        io.write( a .. "\tsub\t" ); writeStack()
    elseif a == "*" then
        push( pop() * pop() )
        io.write( a .. "\tmul\t" ); writeStack()
    elseif a == "/" then
        s = pop(); push( pop() / s )
        io.write( a .. "\tdiv\t" ); writeStack()
    elseif a == "^" then
        s = pop(); push( pop() ^ s )
        io.write( a .. "\tpow\t" ); writeStack()
    elseif a == "%" then
        s = pop(); push( pop() % s )
        io.write( a .. "\tmod\t" ); writeStack()
    else
        push( tonumber( a ) )
        io.write( a .. "\tpush\t" ); writeStack()
    end
end
function calc( s )
    local t, a = "", ""
    print( "\nINPUT", "OP", "STACK" )
    for i = 1, #s do
        a = s:sub( i, i )
        if a == " " then operate( t ); t = ""
        else t = t .. a
        end
    end
    if a ~= "" then operate( a ) end
    print( string.format( "\nresult: %.13f", pop() ) )
end
--[[ entry point ]]--
calc( "3 4 2 * 1 5 - 2 3 ^ ^ / +" )
calc( "22 11 *" )
