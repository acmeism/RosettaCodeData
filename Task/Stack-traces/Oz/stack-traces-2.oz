%% make sure that simple function calls are not optimized away
\switch +controlflowinfo

declare
  [Debug] = {Link ['x-oz://boot/Debug']}

  proc {F} {G} end

  proc {G} {H} end

  proc {H}
     {Inspect {Debug.getTaskStack {Thread.this} 100 true}}
  end
in
   {F}
