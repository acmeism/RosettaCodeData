def task: if . > 0 then ., (./2 | floor | task) else empty end;
1024|task
