recursive function binarySearch_R (a, value) result (bsresult)
    real, intent(in) :: a(:), value
    integer          :: bsresult, mid

    mid = size(a)/2 + 1
    if (size(a) == 0) then
        bsresult = 0        ! not found
    else if (a(mid) > value) then
        bsresult= binarySearch_R(a(:mid-1), value)
    else if (a(mid) < value) then
        bsresult = binarySearch_R(a(mid+1:), value)
        if (bsresult /= 0) then
            bsresult = mid + bsresult
        end if
    else
        bsresult = mid      ! SUCCESS!!
    end if
end function binarySearch_R
