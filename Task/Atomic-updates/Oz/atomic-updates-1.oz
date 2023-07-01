declare
  %%
  %% INIT
  %%
  NBuckets = 100
  StartVal = 50
  ExpectedSum = NBuckets * StartVal

  %% Makes a tuple and calls Fun for every field
  fun {Make Label N Fun}
     R = {Tuple.make Label N}
  in
     for I in 1..N do R.I = {Fun} end
     R
  end

  Buckets = {Make buckets NBuckets fun {$} {Cell.new StartVal} end}
  Locks = {Make locks NBuckets Lock.new}
  LockList = {Record.toList Locks}

  %%
  %% DISPLAY
  %%
  proc {Display}
     Snapshot = {WithLocks LockList
                 fun {$}
                    {Record.map Buckets Cell.access}
                 end
                }
     Sum = {Record.foldL Snapshot Number.'+' 0}
  in
     {Print Snapshot}
     {System.showInfo "  sum: "#Sum}
     Sum = ExpectedSum %% assert
  end

  %% Calls Fun with multiple locks locked and returns the result of Fun.
  fun {WithLocks Ls Fun}
     case Ls of L|Lr then
        lock L then
           {WithLocks Lr Fun}
        end
     [] nil then {Fun}
     end
  end

  %%
  %% MANIPULATE
  %%
  proc {Smooth I J}
     Diff = @(Buckets.I) - @(Buckets.J) %% reading without lock: by design
     Amount = Diff div 4
  in
     {Transfer I J Amount}
  end

  proc {Roughen I J}
     Amount = @(Buckets.I) div 3 %% reading without lock: by design
  in
     {Transfer I J Amount}
  end

  %% Atomically transfer an amount from From to To.
  %% Negative amounts are allowed;
  %% will never make a bucket negative.
  proc {Transfer From To Amount}
     if From \= To then
        %% lock in order (to avoid deadlocks)
        Smaller = {Min From To}
        Bigger = {Max From To}
     in
        lock Locks.Smaller then
           lock Locks.Bigger then
              FromBucket = Buckets.From
              ToBucket = Buckets.To
              NewFromValue = @FromBucket - Amount
              NewToValue = @ToBucket + Amount
           in
              if NewFromValue >= 0 andthen NewToValue >= 0 then
                 FromBucket := NewFromValue
                 ToBucket := NewToValue
              end
           end
        end
     end
   end

  %% Returns a random bucket index.
  fun {Pick}
     {OS.rand} mod NBuckets + 1
  end
in
  %%
  %% START
  %%
  thread for do {Smooth {Pick} {Pick}} end end
  thread for do {Roughen {Pick} {Pick}} end end
  for do {Display} {Time.delay 50} end
