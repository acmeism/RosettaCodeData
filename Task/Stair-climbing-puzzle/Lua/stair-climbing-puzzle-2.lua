-- since lua does not have ! for negation, the example above is wrong.
--Lua uses the ~ instead of the !, but in this case we have to use the not


function step_up()
 while not step() do step_up() end
end
