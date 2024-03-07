      program code_translation
          use iso_fortran_env , only:real64 , real32
          use helpers
          implicit none
          integer :: i
          character(len = 300) :: input_string
          character(len = *) , parameter :: filnam = "airports.csv"
          character(len = *) , parameter :: delimiter = ","
          character(len = 100) :: tokens(20)
          integer :: num_tokens
          integer :: iostat , counter
          type(airport) , allocatable :: airports(:)
          type(whereme) :: location
          integer :: ii , jj
          real(real64) :: dist
          location%latitude = (51.514669D0)!Rosetta co-ords
          location%longitude = (2.19858D0)
 !Nearest to latitude 51.51467,longitude 2.19858 degrees
 !
 !Open the file for reading
          open(unit = 10 , file = 'airports.csv' , status = 'OLD' ,             &
              &action = 'READ' , iostat = iostat , encoding = 'UTF-8')
          if( iostat/=0 )stop 'Could not open file'
          counter = 0
          do
              read(10 , '(a)' , end = 100)input_string
              counter = counter + 1
          end do
 100      continue  ! Now we know how many elements there are
          rewind(unit = 10)
          write(*, '(a,1x,i0,1x,a)') 'Scanning',counter,'lines'
          allocate(airports(counter))
          call system_clock(count = ii)
          do i = 1 , counter
              read(10 , '(a)' , end = 200)input_string
              call tokenizes(input_string , tokens , num_tokens , ',')
              read(tokens(1) , *)airports(i)%airportid
              airports(i)%name = trim(adjustl(tokens(2)))
              airports(i)%city = trim(adjustl(tokens(3)))
              airports(i)%country = trim(adjustl(tokens(4)))
              airports(i)%iata = trim(adjustl(tokens(5)))
              airports(i)%icao = trim(adjustl(tokens(6)))
              read(tokens(7) , '(f20.16)')airports(i)%latitude
              read(tokens(8) , '(F20.16)')airports(i)%longitude
              read(tokens(9) , *)airports(i)%altitude
              read(tokens(10) , '(F5.2)' )airports(i)%timezone
              airports(i)%dst = trim(adjustl(tokens(11)))
              airports(i)%tzolson = trim(adjustl(tokens(12)))
              airports(i)%typez = trim(adjustl(tokens(13)))
              airports(i)%source = trim(adjustl(tokens(14)))
              ! Calculate the distance and bearing straight away
              airports(i)%distance = haversine(location%latitude ,              &
                                   & location%longitude , airports(i)%latitude ,&
                                   & airports(i)%longitude)
              airports(i)%bearing = bearing(location%latitude ,                 &
                                  & location%longitude , airports(i)%latitude , &
                                  & airports(i)%longitude)
          end do
 200      continue
          call system_clock(count = jj)
          write(* , *) 'Read complete, time taken = ' , (jj - ii) ,               &
              & 'milliseconds' // char(10) // char(13)
          call sortem(airports) ! Sort the airports out
          write(*, '(/,2x,a,t14,a,t75,a,t95,a,t108,a,t117,a)')  'Num' , 'Name' ,   &
               &'Country' , 'ICAO' , 'Dist.' , 'Bearing'
          write(*, '(a)') repeat('=' , 130)
          do jj = 1 , 20!First 20 only
              write(*, '(i5,t8,a,t75,a,t95,a,t105,f8.1,t117,i0)') airports(jj)    &
                  & %airportid , airports(jj)%name , airports(jj)%country ,     &
                  & airports(jj)%icao , airports(jj)%distance ,                 &
                  & nint(airports(jj)%bearing)
          end do
          stop 'Normal completion' // char(10) // char(13)
      end program code_translation
      module helpers
          use iso_fortran_env , only:real32,real64
          implicit none
          real(real64) , parameter :: radius_in_km = 6372.8D0
          real(real64) , parameter :: kilos_to_nautical = 0.5399568D0
          type whereme
              real(real64) :: latitude , longitude
          end type whereme
          type airport
              integer :: airportid
              character(len = 100) :: name
              character(len = 50) :: city , country
              character(len = 10) :: iata , icao
              real(real64) :: latitude , longitude
              integer :: altitude
              real(real32) :: timezone
              character(len = 10) :: dst
              character(len = 100) :: tzolson
              character(len = 20) :: typez , source
              real(real64) :: distance , bearing
          end type airport
      contains                                ! We'll calculate them and store in each airport
 !
 ! The given angles are in radians, and the result is in degrees in the range [0, 360).
          function bearing(lat1 , lon1 , lat2 , lon2)
              real(real64) , parameter :: toradians = acos( - 1.0D0)/180.0D0
              real(real64) :: bearing
              real(real64) , intent(in) :: lat1
              real(real64) , intent(in) :: lon1
              real(real64) , intent(in) :: lat2
              real(real64) , intent(in) :: lon2
              real(real64) :: dlat
              real(real64) :: dlon
              real(real64) :: rlat1
              real(real64) :: rlat2
              real(real64) :: x
              real(real64) :: y
 !
              dlat = (lat2 - lat1)*toradians
              dlon = toradians*(lon2 - lon1)
              rlat1 = toradians*(lat1)
              rlat2 = toradians*(lat2)
                            !
              x = cos(rlat2)*sin(dlon)
              y = cos(rlat1)*sin(rlat2) - sin(rlat1)*cos(rlat2)*cos(dlon)
              bearing = atan2(x , y)
              bearing = to_degrees(bearing)
              bearing = mod(bearing + 360.0D0 , 360.0D0)
          end function bearing
 !
 !
          function to_radian(degree) result(rad)
              real(real64) , parameter :: deg_to_rad = atan(1.0D0)/45.0D0 ! exploit intrinsic atan to generate pi/180 runtime constant
 !
              real(real64) :: rad
              real(real64) , intent(in) :: degree
          ! degrees to radians
              rad = degree*deg_to_rad
          end function to_radian
 !
          function to_degrees(radians) result(deg)
              real(real64) , parameter :: radian_to_degree = 180.0D0/acos( - 1.0D0)
 !
              real(real64) :: deg
              real(real64) , intent(in) :: radians
              deg = radians*radian_to_degree
          end function to_degrees
    !
          function haversine(deglat1 , deglon1 , deglat2 , deglon2) result(dist)
              real(real64) :: dist
              real(real64) , intent(in) :: deglat1
              real(real64) , intent(in) :: deglon1
              real(real64) , intent(in) :: deglat2
              real(real64) , intent(in) :: deglon2
              real(real64) :: a
              real(real64) :: c
              real(real64) :: dlat
              real(real64) :: dlon
              real(real64) :: lat1
              real(real64) :: lat2
          ! great circle distance
              dlat = to_radian(deglat2 - deglat1)
              dlon = to_radian(deglon2 - deglon1)
              lat1 = to_radian(deglat1)
              lat2 = to_radian(deglat2)
              a = (sin(dlat/2.0D0)**2) + cos(lat1)*cos(lat2)                    &
                & *((sin(dlon/2.0D0))**2)
              c = 2.0D0*asin(sqrt(a))
              dist = radius_in_km*c*kilos_to_nautical
          end function haversine
          subroutine sortem(airports)!Bubble sort them, nice and easy
              type(airport) , intent(inout) , dimension(:) :: airports
              integer :: i
              integer :: k
              logical :: swapped
              type(airport) :: temp
              swapped = .true.
              k = size(airports%distance)
              do while ( swapped )
                  swapped = .false.
                  do i = 1 , k - 1
                      if( airports(i)%distance>airports(i + 1)%distance )then
                          temp = airports(i)
                          airports(i) = airports(i + 1)
                          airports(i + 1) = temp
                          swapped = .true.
                      end if
                  end do
              end do
              return
          end subroutine sortem
 !
          subroutine tokenizes(input_string , tokens , num_tokens , delimiter)
              character(*) , intent(in) :: input_string
              character(*) , intent(out) , dimension(:) :: tokens
              integer , intent(out) :: num_tokens
              character(1) , intent(in) :: delimiter
              integer :: end_idx
              integer :: i
              integer :: start_idx
              character(100) :: temp_string
              num_tokens = 0
              temp_string = trim(input_string)
              start_idx = 1
              do i = 1 , len_trim(temp_string)
                  if( (temp_string(i:i)==delimiter) )then
                      end_idx = i - 1
                      if( end_idx>=start_idx )then
                          num_tokens = num_tokens + 1
                          tokens(num_tokens) = ''
                          tokens(num_tokens) = temp_string(start_idx:end_idx)
                      end if
                      start_idx = i + 1
                  end if
              end do
        ! Handle the last token
              if( start_idx<=len_trim(temp_string) )then
                  num_tokens = num_tokens + 1
                  tokens(num_tokens) = temp_string(start_idx:len_trim(          &
                                     & temp_string))
              end if
          end subroutine tokenizes
 !
      end module helpers
 !
