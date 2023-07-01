Program eee
implicit none
integer, parameter  :: QP = selected_real_kind(16)
real(QP), parameter :: one = 1.0
real(QP)            :: ee

write(*,*) '    exp(1.) ', exp(1._QP)

ee = 1. +(one +(one +(one +(one +(one+ (one +(one +(one +(one +(one +(one &
        +(one +(one +(one +(one +(one +(one +(one +(one +(one +(one)      &
        /21.)/20.)/19.)/18.)/17.)/16.)/15.)/14.)/13.)/12.)/11.)/10.)/9.)  &
        /8.)/7.)/6.)/5.)/4.)/3.)/2.)

write(*,*) ' polynomial ', ee
			
end Program eee
