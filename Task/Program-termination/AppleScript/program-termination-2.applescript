on idle -- A stay-open applet's 'idle' handler is called periodically while the applet remains open.
    -- Some code, including:
    if (someCondition) then
        quit -- Quit the applet when the script stops executing.
        error number -128 -- Stop executing the script. (Not necessary on recent systems.)
    end if

    return 10 -- Number of seconds to the next call of this handler if the applet's still open.
end idle
