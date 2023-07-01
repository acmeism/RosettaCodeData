/* Rexx */
/*-- ~~ main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
call run_samples
return
exit

/*-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/*-- returns a comma separated string of mode values from a comma separated input vector string */
mode:
  procedure
  parse arg lvector
  drop vector.
  vector. = ''
  call makeStem lvector /*-- this call creates the "vector." stem from the input string */
  seen.   = 0
  modes.  = ''
  modeMax = 0
  do v_ = 1 to vector.0
    mv = vector.v_
    seen.mv = seen.mv + 1
    select
      when seen.mv > modeMax then do
        modeMax = seen.mv
        drop modes.
        modes. = ''
        nx = 1
        modes.0  = nx
        modes.nx = mv
        end
      when seen.mv = modeMax then do
        nx = modes.0 + 1
        modes.0  = nx
        modes.nx = mv
        end
      otherwise do
        nop
        end
      end
    end v_

  lmodes = ''
  do e_ = 1 to modes.0
    lmodes = lmodes modes.e_
    end e_
  lmodes = strip(space(lmodes, 1, ','))

  return lmodes

/*-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/*-- pretty-print */
show_mode:
  procedure
  parse arg lvector
  lmodes = mode(lvector)
  say 'Vector: ['space(lvector, 0)'], Mode(s): ['space(lmodes, 0)']'
  return modes

/*-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/*-- load the "vector." stem from the comma separated input vector string */
makeStem:
  procedure expose vector.
  vector.0 = 0
  parse arg lvector
  do v_ = 1 while lvector \= ''
    parse var lvector val ',' lvector
    vector.0 = v_
    vector.v_ = strip(val)
    vector = strip(lvector)
    end v_
  return vector.0

/*-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
run_samples:
  procedure
  call show_mode '10, 9, 8, 7, 6, 5, 4, 3, 2, 1'                     -- 10 9 8 7 6 5 4 3 2 1
  call show_mode '10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 0, 0, 0.11'   -- 0
  call show_mode '30, 10, 20, 30, 40, 50, -100, 4.7, -11e+2'         -- 30
  call show_mode '30, 10, 20, 30, 40, 50, -100, 4.7, -11e+2, -11e+2' -- 30 -11e2
  call show_mode '1, 8, 6, 0, 1, 9, 4, 6, 1, 9, 9, 9'                -- 9
  call show_mode '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11'                 -- 1 2 3 4 5 6 7 8 9 10 11
  call show_mode '8, 8, 8, 2, 2, 2'                                  -- 8 2
  call show_mode 'cat, kat, Cat, emu, emu, Kat'                      -- emu
  call show_mode '0, 1, 2, 3, 3, 3, 4, 4, 4, 4, 1, 0'                -- 4
  call show_mode '2, 7, 1, 8, 2'                                     -- 2
  call show_mode '2, 7, 1, 8, 2, 8'                                  -- 8 2
  call show_mode 'E, n, z, y, k, l, o, p, ä, d, i, e'                -- E n z y k l o p ä d i e
  call show_mode 'E, n, z, y, k, l, o, p, ä, d, i, e, ä'             -- ä
  call show_mode '3, 1, 4, 1, 5, 9, 7, 6'                            -- 1
  call show_mode '3, 1, 4, 1, 5, 9, 7, 6, 3'                         -- 3, 1
  call show_mode '1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17'                -- 6
  call show_mode '1, 1, 2, 4, 4'                                     -- 4 1
  return
