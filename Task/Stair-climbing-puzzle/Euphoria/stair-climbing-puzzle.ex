procedure step_up()
    if not step() then
        step_up()
        step_up()
    end if
end procedure
