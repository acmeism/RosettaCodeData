! Long literals, with continuations
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
! but not VSI Fortran x86-64 V8.7-001 because that compiler does not accept
! allocatable character variables
!
program longstring
implicit none

! We want to define an array of the element names.
! The array should have a dynamically allocatable number of entries,
! and each entry should be a character string of dynamicaolly allocatable length
! to varry the names without leading or trailing spaces
!
type dynString_t                                  ! This type is for the name of 1 element
  character (len=:), allocatable :: val
end type dynString_t

type(dynString_t), allocatable :: elements(:)     ! This becomes the final array of element names.


! Define 1 long literal containing the named chemical elements.
! The element names are separated by a single space.
! Note that the first quote (') in front of "hydrogen" marks the beginning of the string,
! and the last quote after "oganesson" marks the end of the string. No Concatenation is needed.
! The ampersand (&) at the end of each line indicates that a continuation line follows,
! and the ampersand at the beginning of each continuation line is not part of the string
! but indicates the beginning of the continuation. All text between the two ampersands
! in each line, including trailing or leading spaces, is part of the defined list of
! element names.

character (len=*), parameter :: pElementString = '&
&hydrogen helium lithium beryllium boron carbon nitrogen oxy&
&gen fluorine neon sodium magnesium aluminum silicon phosphorous sulfur chl&
&orine argon potassium calcium scandium titanium vanadium chromium manganes&
&e iron cobalt nickel copper zinc gallium germanium arsenic selenium bromin&
&e krypton rubidium strontium yttrium zirconium niobium molybdenum techneti&
&um ruthenium rhodium palladium silver cadmium indium tin antimony telluriu&
&m iodine xenon cesium barium lanthanum cerium praseodymium neodymium prome&
&thium samarium europium gadolinium terbium dysprosium holmium erbium thuli&
&um ytterbium lutetium hafnium tantalum tungsten rhenium osmium iridium pla&
&tinum gold mercury thallium lead bismuth polonium astatine radon francium &
&radium actinium thorium protactinium uranium neptunium plutonium americium&
& curium berkelium californium einsteinium fermium mendelevium nobelium law&
&rencium rutherfordium dubnium seaborgium bohrium hassium meitnerium darmst&
&adtium roentgenium copernicium nihonium flerovium moscovium livermorium te&
&nnessine oganesson'

character (len=*), parameter :: revisionDate = '23-Feb-2026'
integer :: elementCount

call separate (pElementString, elements)
elementCount = size (elements)
write ( *, '("Last revision date             : ", A)')  revisionDate
write ( *, '("Number of elements in the list : ", i0)') elementCount
write ( *, '("The last element in the list   : ", A)')  elements (elementCount)%val



contains

! =============================================================================
! parse the input string, which is a list of element names, separated by commas.
! Result is a vector that holds the names from the input string, without
! extra spaces.
! =============================================================================

subroutine separate (string, vec)
character (len=*), intent(in) :: string

type(dynString_t), allocatable, intent(out) :: vec(:)

integer :: l                  ! Length of the input string
integer :: ip1, ip2           ! Two indices into the string, mark beginning and end of a name
integer :: elementCnt, idx

l = len_trim (string)         ! Beware of trailing spaces in puput

! Two passes are required.
! In the first pass, find out how many element names there are in the string
! then we can reserve just enough space for the element names.

ip1 = 1
ip2 = 1
elementCnt = 0
do while (ip1 .ne. 0)
  ! Here we either have found a separating space character, or the end of the input string
  ! in both cases we have another element name, starting at previous value of ip1
  ip1 = index (string(ip2:l),' ')
  elementCnt = elementCnt + 1
  ip2 = ip2 + ip1
  if (ip1 .ne. 0) then                      ! We need to skip multiple spaces
    do while (ip2 .le. l .and. string(ip2:ip2) .eq. ' ')
      ip2 = ip2 + 1
    end do
  endif
enddo
allocate (vec (elementCnt) )    ! Create storage space for all element names

! In the second pass, separate the names and fill the array.
ip1 = 1                                 ! shall mark the beginning of each name
ip2 = 1                                 ! shall mark the end of each name
idx = 0                                 ! index into the resulkt vecor
do while (ip2 .lt. l)                   ! Loop until the end reached
  do while (string(ip2:ip2) .eq. ' ')   ! SKip blanks up to the end or to a non-blank character
    ip2 = ip2 + 1
  end do
  ip1 = ip2                             ! Here the next element name begins

  do while (string(ip2:ip2) .ne. ' '  & ! find the end of current name string
      .and. ip2 .lt. l)                 ! or the end of the entire input string, whatever comes first
    ip2 = ip2 + 1
  end do
  idx = idx + 1                         ! We have a new element name
  if (string(ip2:ip2) .eq. ' ')  then   ! Not yet at the end: ip2 points to a space character
    vec(idx)%val = string (ip1:ip2-1)
  else                                  ! At the end: ip2 points to the last character
    vec(idx)%val = string(ip1:ip2)
  endif
end do
end subroutine separate

end program longstring
