Enqueue := function(v, x)
    Add(v[1], x);
end;

Dequeue := function(v)
    if IsEmpty(v[2]) then
        if IsEmpty(v[1]) then
            return fail;
        else
            v[2] := Reversed(v[1]);
            v[1] := [];
        fi;
    fi;
    return Remove(v[2]);
end;


# a new queue
v := [[], []];

Enqueue(v, 3);
Enqueue(v, 4);
Enqueue(v, 5);
Dequeue(v);
# 3
Enqueue(v, 6);
Dequeue(v);
# 4
Dequeue(v);
# 5
Dequeue(v);
# 6
Dequeue(v);
# fail
