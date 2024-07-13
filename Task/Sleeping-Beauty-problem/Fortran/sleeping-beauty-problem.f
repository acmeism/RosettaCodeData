program sleepingbeauty
    implicit none

    integer :: total_reps
    integer :: result_wakings
    real :: result_percent

    total_reps = 1e6

    call sleepingOp(total_reps, result_wakings, result_percent)

    print *, "wakings over", total_reps, "reps: ", result_wakings
    print *, "percentage probability of heads on wake:", result_percent

contains

subroutine sleepingOp(reps, wakings, percent)
    integer, intent(in) :: reps
    integer, intent(out) :: wakings
    real, intent(out) :: percent

    integer :: heads
    integer :: i
    real :: coin

    wakings = 0
    heads = 0

    do i = 0, reps, 1
        call random_number(coin)
        wakings = wakings + 1
        if (coin > 0.5) then
            heads = heads + 1
        else
            wakings = wakings + 1
        end if
    end do

    percent = real(heads) / real(wakings)

end subroutine sleepingOp

end program sleepingbeauty
