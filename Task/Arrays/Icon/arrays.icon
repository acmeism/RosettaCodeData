record aThing(a, b, c)       # arbitrary object (record or class) for illustration

procedure main()
    A0 := []                 # empty list
    A0 := list()             # empty list (default size 0)
    A0 := list(0)            # empty list (literal size 0)

    A1 := list(10)           # 10 elements, default initializer &null
    A2 := list(10, 1)        # 10 elements, initialized to 1

    # literal array construction - arbitrary dynamically typed members
    A3 := [1, 2, 3, ["foo", "bar", "baz"], aThing(1, 2, 3), "the end"]

    # left-end workers
    # NOTE: get() is a synonym for pop() which allows nicely-worded use of put() and get() to implement queues
    #
    Q := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    x := pop(A0)        # x is 1
    x := get(A0)        # x is 2
    push(Q,0)
    # Q is now [0,3, 4, 5, 6, 7, 8, 9, 10]

    # right-end workers
    x := pull(Q)        # x is 10
    put(Q, 100)         # Q is now [0, 3, 4, 5, 6, 7, 8, 9, 100]

    # push and put return the list they are building
    # they also can have multiple arguments which work like repeated calls

    Q2 := put([],1,2,3)    # Q2 is [1,2,3]
    Q3 := push([],1,2,3)   # Q3 is [3,2,1]
    Q4 := push(put(Q2),4),0] # Q4 is [0,1,2,3,4] and so is Q2

    # array access follows with A as the sample array
    A := [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

    # get element indexed from left
    x := A[1]           # x is 10
    x := A[2]           # x is 20
    x := A[10]          # x is 100

    # get element indexed from right
    x := A[-1]          # x is 100
    x := A[-2]          # x is 90
    x := A[-10]         # x is 10

    # copy array to show assignment to elements
    B := copy(A)

    # assign element indexed from left
    B[1] := 11
    B[2] := 21
    B[10] := 101
    # B is now [11, 21, 30, 50, 60, 60, 70, 80, 90, 101]

    # assign element indexed from right - see below
    B[-1] := 102
    B[-2] := 92
    B[-10] := 12
    # B is now [12, 21, 30, 50, 60, 60, 70, 80, 92, 102]

    # list slicing
    # the unusual nature of the slice - returning 1 less element than might be expected
    # in many languages - is best understood if you imagine indexes as pointing to BEFORE
    # the item of interest. When a slice is made, the elements between the two points are
    # collected. eg in the A[3 : 6] sample, it will get the elements between the [ ] marks
    #
    # sample list:              10  20 [30  40  50] 60  70  80  90  100
    # positive indexes:        1   2   3   4   5   6   7   8   9   10  11
    # non-positive indexes:  -10  -9  -8  -7  -6  -5  -4  -3  -2  -1   0
    #
    # I have deliberately drawn the indexes between the positions of the values.
    # The nature of this indexing brings simplicity to string operations
    #
    # list slicing can also use non-positive indexes to access values from the right.
    # The final index of 0 shown above shows how the end of the list can be nominated
    # without having to know it's length
    #
    # NOTE: list slices are distinct lists, so assigning to the slice
    # or a member of the slice does not change the values in A
    #
    # Another key fact to understand: once the non-positive indexes and length-offsets are
    # resolved to a simple positive index, the index pair (if two are given) are swapped
    # if necessary to yield the elements between the two.
    #
    S := A[3 : 6]       # S is [30, 40, 50]
    S := A[6 : 3]       # S is [30, 40, 50]   not illegal or erroneous
    S := A[-5 : -8]     # S is [30, 40, 50]
    S := A[-8 : -5]     # S is [30, 40, 50]   also legal and meaningful

    # list slicing with length request
    S := A[3 +: 3]      # S is [30, 40, 50]
    S := A[6 -: 3]      # S is [30, 40, 50]
    S := A[-8 +: 3]     # S is [30, 40, 50]
    S := A[-5 -: 3]     # S is [30, 40, 50]
    S := A[-8 -: -3]    # S is [30, 40, 50]
    S := A[-5 +: -3]    # S is [30, 40, 50]
end
