tree = Any[1, Any[2, Any[4, Any[7, Any[],
                                          Any[]],
                                   Any[]],
                            Any[5, Any[],
                                   Any[]]],
                     Any[3, Any[6, Any[8, Any[],
                                          Any[]],
                                   Any[9, Any[],
                                          Any[]]],
                            Any[]]]

preorder(t, f) = if !isempty(t)
                     f(t[1]); preorder(t[2], f); preorder(t[3], f)
                 end

inorder(t, f) = if !isempty(t)
                    inorder(t[2], f); f(t[1]); inorder(t[3], f)
                end

postorder(t, f) = if !isempty(t)
                      postorder(t[2], f); postorder(t[3], f); f(t[1])
                  end

levelorder(t, f) = while !isempty(t)
                       t = mapreduce(x -> isa(x, Number) ? (f(x); []) : x, vcat, t)
                   end
