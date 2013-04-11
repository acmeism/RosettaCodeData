program example
implicit none
real :: d

d = haversine(36.12,-86.67,33.94,-118.40) ! BNA to LAX
print '(A,F9.4,A)', 'distance: ',d,' km' ! distance: 2887.2600 km

contains

      function to_radian(degree) result(rad)
          ! degrees to radians
          real,intent(in) :: degree
          real :: rad,pi

          pi = 4*atan(1.0)  ! exploit intrinsic atan to generate pi
          rad = degree*pi/180
      end function to_radian

      function haversine(deglat1,deglon1,deglat2,deglon2) result (dist)
          ! great circle distance -- adapted from Matlab
          real,intent(in) :: deglat1,deglon1,deglat2,deglon2
          real :: a,c,dist,dlat,dlon,lat1,lat2
          real,parameter :: radius = 6372.8

          dlat = to_radian(deglat2-deglat1)
          dlon = to_radian(deglon2-deglon1)
          lat1 = to_radian(deglat1)
          lat2 = to_radian(deglat2)
          a = (sin(dlat/2))**2 + cos(lat1)*cos(lat2)*(sin(dlon/2))**2
          c = 2*atan2(sqrt(a),sqrt(1-a))
          dist = radius*c
      end function haversine

end program example
