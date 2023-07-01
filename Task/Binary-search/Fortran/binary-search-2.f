function binarySearch_I (a, value)
    integer                  :: binarySearch_I
    real, intent(in), target :: a(:)
    real, intent(in)         :: value
    real, pointer            :: p(:)
    integer                  :: mid, offset

    p => a
    binarySearch_I = 0
    offset = 0
    do while (size(p) > 0)
        mid = size(p)/2 + 1
        if (p(mid) > value) then
            p => p(:mid-1)
        else if (p(mid) < value) then
            offset = offset + mid
            p => p(mid+1:)
        else
            binarySearch_I = offset + mid    ! SUCCESS!!
            return
        end if
    end do
end function binarySearch_I
