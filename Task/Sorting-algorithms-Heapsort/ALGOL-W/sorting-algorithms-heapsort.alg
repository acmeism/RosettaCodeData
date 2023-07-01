begin % heapsort - translated from the PL/M sample %

    % in-place heapsorts a, a must have bounds 0 :: count - 1 %
    procedure heapSort ( integer array a ( * ); integer value count ) ;
    begin
        procedure siftDown ( integer array a ( * ); integer value start, endv ) ;
        begin
            integer root, child, temp;
            logical done;
            root := start;
            done := false;
            while begin
                      child := ( root * 2 ) + 1;
                      child <= endv and not done
                  end
            do begin
                if child + 1 <= endv and a( child ) < a( child + 1 ) then child := child + 1;
                if a( root ) < a( child ) then begin
                    temp       := a( root );
                    a( root  ) := a( child );
                    a( child ) := temp;
                    root       := child
                    end
                else done := true
            end while_child_le_endv_and_not_done
        end siftDown ;
        procedure heapify ( integer array a ( * ); integer value count ) ;
        begin
            integer start;
            start := ( count - 2 ) div 2;
            while begin
                siftDown( a, start, count - 1 );
                if start = 0
                then false
                else begin
                    start := start - 1;
                    true
                end if_start_eq_0__
            end do begin end
        end heapify ;
        begin % heapSort body %
            integer endv, temp;
            heapify( a, count );
            endv := count - 1;
            while endv > 0 do begin
                temp      := a( 0 );
                a( 0 )    := a( endv );
                a( endv ) := temp;
                endv      := endv - 1;
                siftDown( a, 0, endv )
            end while_endv_gt_0
        end heapSortBody
    end heapSort;

    begin % test heapSort %
        integer array numbers ( 0 :: 10 );
        integer nPos;
        % constructy an array of integers and sort it %
        nPos := 0;
        for v := 4, 65, 2, 31, 0, 99, 2, 8, 3, 782, 1 do begin
            numbers( nPos ) := v;
            nPos            := nPos + 1
        end for_v ;
        heapSort( numbers, 11 );
        % print the sorted array %
        for n := 0 until 10 do writeon( i_w := 1, s_w := 0, " ", numbers( n ) )
    end tests
end.
