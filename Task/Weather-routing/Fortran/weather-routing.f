program weather_routing
   implicit none
   integer, parameter :: dp = selected_real_kind(15, 307)
   real(kind=dp), parameter :: pi = 3.141592653589793_dp
   real(kind=dp), parameter :: r = 6372800.0_dp
   integer, parameter :: timeinterval = 10

   real(kind=dp), allocatable :: winds(:), degrees(:), speeds(:, :)
   character(9) :: chart(9)
   integer :: nwinds, ndegrees

   type point
      real(kind=dp) :: lat, lon
   end type point

   type surface_params
      real(kind=dp) :: winddirection, windvelocity, currentdirection, currentvelocity
   end type surface_params

   type grid_point
      type(point) :: pt
      type(surface_params) :: surf
   end type grid_point

   type(grid_point), allocatable :: slices(:, :, :)

   integer :: path(2, 100), pathlen
   character(20) :: timestr, durstr

   call read_polar_data()
   call init_chart()
   call init_slices()
   call find_route(path, pathlen, durstr, timestr)
   call print_results(path, pathlen, durstr, timestr)

contains

   subroutine read_polar_data()
      character(5000) :: polar_csv
      character(200) :: lines(50), tokens(40)
      integer :: nlines, ntok, i, j, ios
      real(kind=dp) :: val

      polar_csv = "TWA\TWS;0;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;35;40;60;70" // &
            new_line('a') // "40;0;0.53;0.54;0.49;0.4;0.31;0.21;0.16;0.11;0.08;0.05;0.03;0.02;0.01;0;0;0;0;0;0;0;0;0;0;0;0;0;0;-0.0&
            &1;-0.05;-0.1;-0.11" // &
            new_line('a') // "41;0;0.61;0.62;0.56;0.47;0.36;0.25;0.19;0.14;0.1;0.07;0.04;0.02;0.01;0.01;0;0;0;0;0;0;0;0;0;0;0;0;0;0&
            &;-0.04;-0.09;-0.1" // &
            new_line('a') // "44;0;0.89;0.91;0.82;0.69;0.56;0.42;0.33;0.24;0.18;0.13;0.08;0.05;0.03;0.02;0.01;0.01;0;0;0;0;0;0;0;0;&
            &0;0;0;0;-0.02;-0.06;-0.06" // &
            new_line('a') // "45;0;0.99;1.02;0.92;0.78;0.64;0.49;0.39;0.29;0.22;0.15;0.1;0.07;0.04;0.02;0.01;0.01;0;0;0;0;0;0;0;0;0&
            &;0;0;0;-0.01;-0.05;-0.05" // &
            new_line('a') // "46;0;1.11;1.14;1.02;0.87;0.73;0.57;0.45;0.35;0.26;0.18;0.13;0.08;0.05;0.03;0.02;0.01;0.01;0;0;0;0;0;0&
            &;0;0;0;0;0;-0.01;-0.04;-0.05" // &
            new_line('a') // "47;0;1.23;1.25;1.14;0.97;0.82;0.66;0.53;0.41;0.31;0.22;0.15;0.1;0.07;0.04;0.02;0.02;0.01;0.01;0;0;0;0&
            &;0;0;0;0;0;0;-0.01;-0.03;-0.04" // &
            new_line('a') // "48;0;1.37;1.37;1.26;1.08;0.93;0.76;0.61;0.48;0.36;0.26;0.19;0.13;0.08;0.05;0.03;0.02;0.01;0.01;0.01;0&
            &;0;0;0;0;0;0;0;0;0;-0.02;-0.03" // &
            new_line('a') // "49;0;1.5;1.5;1.39;1.2;1.05;0.87;0.71;0.56;0.42;0.31;0.22;0.15;0.1;0.07;0.04;0.03;0.02;0.01;0.01;0;0;0&
            &;0;0;0;0;0;0;0;-0.02;-0.02" // &
            new_line('a') // "50;0;1.65;1.64;1.52;1.33;1.18;1;0.81;0.65;0.49;0.37;0.26;0.19;0.13;0.08;0.05;0.04;0.03;0.02;0.01;0.01&
            &;0;0;0;0;0;0;0;0;0;-0.01;-0.02" // &
            new_line('a') // "51;0;1.79;1.77;1.67;1.46;1.32;1.13;0.92;0.74;0.57;0.43;0.31;0.22;0.15;0.1;0.07;0.05;0.03;0.02;0.02;0.&
            &01;0.01;0;0;0;0;0;0;0;0;-0.01;-0.02" // &
            new_line('a') // "53;0;2.1;2.07;1.99;1.76;1.62;1.4;1.14;0.95;0.74;0.57;0.43;0.31;0.22;0.16;0.1;0.08;0.06;0.04;0.03;0.02&
            &;0.01;0.01;0.01;0;0;0;0;0;0;-0.01;-0.01" // &
            new_line('a') // "54;0;2.26;2.22;2.16;1.92;1.78;1.55;1.28;1.06;0.84;0.65;0.5;0.37;0.27;0.19;0.13;0.1;0.07;0.06;0.04;0.0&
            &3;0.02;0.01;0.01;0;0;0;0;0;0;0;-0.01" // &
            new_line('a') // "55;0;2.43;2.39;2.34;2.09;1.95;1.7;1.42;1.18;0.95;0.74;0.57;0.43;0.32;0.23;0.16;0.12;0.09;0.07;0.05;0.&
            &04;0.03;0.02;0.01;0.01;0;0;0;0;0;0;-0.01" // &
            new_line('a') // "60;0;3.29;3.33;3.33;3.08;2.93;2.64;2.29;1.98;1.66;1.36;1.1;0.88;0.68;0.53;0.39;0.32;0.26;0.21;0.17;0.&
            &13;0.1;0.07;0.05;0.04;0.03;0.02;0.01;0;0;0;0" // &
            new_line('a') // "70;0;5.2;5.53;5.74;5.59;5.5;5.22;4.84;4.46;3.94;3.51;3.08;2.65;2.26;1.9;1.55;1.38;1.22;1.06;0.92;0.78&
            &;0.66;0.55;0.46;0.37;0.3;0.24;0.18;0.03;0;0;0" // &
            new_line('a') // "80;0;6.8;7.43;7.97;8.02;8.23;8.34;8.2;7.9;7.37;6.91;6.43;5.9;5.32;4.72;4.12;3.83;3.55;3.25;2.96;2.67;&
            &2.4;2.13;1.88;1.65;1.43;1.22;1.04;0.37;0.09;0.01;0" // &
            new_line('a') // "90;0;7.59;8.5;9.4;9.73;10.4;11.16;11.53;11.56;11.3;11.05;10.77;10.44;9.83;9.07;8.34;8;7.65;7.27;6.88;&
            &6.46;6.04;5.61;5.15;4.74;4.33;3.88;3.51;1.72;0.67;0.12;0.03" // &
            new_line('a') // "100;0;7.34;8.25;9.16;9.86;10.5;11.95;12.79;13.5;14.02;14.4;14.37;14.5;14.4;13.92;13.52;13.19;12.79;12&
            &.51;12.1;11.66;11.22;10.77;10.26;9.72;9.2;8.58;8.01;4.87;2.51;0.7;0.23" // &
            new_line('a') // "110;0;7.09;7.97;8.84;9.74;10.09;11.85;12.75;13.84;14.99;16.02;16.33;17.1;17.83;17.99;18.32;18.14;17.8&
            &1;17.84;17.6;17.3;17.05;16.83;16.53;16.03;15.59;15.03;14.37;10.26;6.41;2.32;0.86" // &
            new_line('a') // "120;0;6.59;7.42;8.3;9.1;9.56;10.83;11.6;13.1;13.87;14.66;15.75;16.67;17.63;18.43;19.62;20.17;20.6;21.&
            &12;21.55;21.75;21.91;22.07;21.9;21.58;21.29;20.92;20.29;16.47;12.03;5.49;2.26" // &
            new_line('a') // "129;0;6.14;6.93;7.83;8.52;9.09;9.89;10.57;12.42;12.87;13.43;15.23;16.16;17.08;18.07;19.48;20.35;21.22&
            &;21.93;22.85;23.44;23.98;24.55;24.59;24.55;24.51;24.46;24;21.56;17.75;9.64;4.25" // &
            new_line('a') // "130;0;6.07;6.87;7.76;8.44;9.02;9.8;10.48;12.29;12.73;13.27;15.08;16.03;16.97;17.96;19.36;20.25;21.15;&
            &21.88;22.82;23.44;24.03;24.6;24.66;24.68;24.67;24.64;24.24;22;18.33;10.11;4.5" // &
            new_line('a') // "135;0;5.72;6.57;7.36;8.02;8.65;9.38;10.11;11.52;11.97;12.55;13.85;15.31;16.31;17.33;18.54;19.48;20.35&
            &;21.28;22.3;23.08;24.09;24.63;24.69;24.78;24.79;24.91;24.82;23.74;20.98;12.39;5.78" // &
            new_line('a') // "136;0;5.66;6.5;7.28;7.93;8.57;9.3;10.04;11.34;11.82;12.42;13.62;15.06;16.17;17.2;18.35;19.29;20.15;21&
            &.12;22.15;22.96;24.07;24.6;24.67;24.76;24.75;24.85;24.81;23.98;21.45;12.8;6.03" // &
            new_line('a') // "139;0;5.42;6.31;6.92;7.67;8.34;9.08;9.86;10.86;11.32;12.03;12.99;14.3;15.73;16.76;17.76;18.71;19.53;2&
            &0.6;21.66;22.54;23.92;24.44;24.53;24.64;24.58;24.65;24.67;24.47;22.68;13.79;6.73" // &
            new_line('a') // "140;0;5.35;6.22;6.79;7.59;8.26;9;9.8;10.72;11.16;11.89;12.79;14.06;15.5;16.62;17.57;18.51;19.32;20.43&
            &;21.49;22.4;23.84;24.36;24.46;24.58;24.51;24.57;24.61;24.56;23.02;14.08;6.96" // &
            new_line('a') // "141;0;5.29;6.12;6.67;7.48;8.18;8.93;9.74;10.57;11.02;11.77;12.62;13.82;15.26;16.47;17.38;18.32;19.04;&
            &20.28;21.31;22.07;23.53;24;24.21;24.29;24.43;24.48;24.55;24.61;23.33;14.31;7.18" // &
            new_line('a') // "142;0;5.23;6.02;6.57;7.39;8.1;8.86;9.67;10.43;10.88;11.64;12.45;13.59;15.03;16.24;17.14;18.06;18.77;1&
            &9.98;21.01;21.75;23.18;23.65;23.86;23.95;24.34;24.39;24.48;24.61;23.61;14.54;7.4" // &
            new_line('a') // "143;0;5.16;5.93;6.45;7.3;8;8.78;9.54;10.27;10.75;11.5;12.28;13.36;14.8;16.01;16.9;17.81;18.5;19.69;20&
            &.72;21.43;22.84;23.31;23.52;23.61;24.05;24.27;24.41;24.57;23.85;14.8;7.6" // &
            new_line('a') // "144;0;5.09;5.83;6.33;7.23;7.92;8.66;9.41;10.13;10.62;11.39;12.13;13.13;14.57;15.78;16.65;17.56;18.24;&
            &19.41;20.43;21.12;22.5;22.97;23.19;23.28;23.73;24.08;24.33;24.49;24.04;15;7.8" // &
            new_line('a') // "145;0;5.02;5.73;6.23;7.15;7.85;8.55;9.28;9.98;10.51;11.27;11.98;12.92;14.35;15.56;16.42;17.31;17.97;1&
            &9.13;20.14;20.82;22.17;22.64;22.87;22.96;23.42;23.81;24.23;24.41;24.19;15.14;7.98" // &
            new_line('a') // "146;0;4.96;5.64;6.12;7.07;7.77;8.43;9.15;9.84;10.38;11.16;11.83;12.71;14.12;15.35;16.19;17.07;17.72;1&
            &8.86;19.86;20.51;21.84;22.31;22.56;22.65;23.12;23.48;23.94;24.33;24.3;15.3;8.16" // &
            new_line('a') // "148;0;4.82;5.45;5.91;6.9;7.59;8.21;8.89;9.55;10.14;10.89;11.55;12.29;13.7;14.92;15.74;16.6;17.23;18.3&
            &2;19.3;19.91;21.2;21.67;21.95;22.05;22.53;22.87;23.38;24.13;24.39;15.52;8.46" // &
            new_line('a') // "149;0;4.76;5.35;5.81;6.78;7.49;8.09;8.78;9.42;10.01;10.76;11.41;12.1;13.48;14.71;15.52;16.36;16.98;18&
            &.06;19.03;19.63;20.89;21.37;21.67;21.77;22.26;22.61;23.12;23.98;24.37;15.57;8.58" // &
            new_line('a') // "150;0;4.69;5.26;5.7;6.67;7.37;7.96;8.64;9.26;9.86;10.6;11.24;11.89;13.26;14.48;15.29;16.11;16.73;17.7&
            &9;18.74;19.33;20.55;21.04;21.37;21.48;21.98;22.34;22.83;23.69;24.11;15.6;8.67" // &
            new_line('a') // "155;0;4.33;4.74;5.16;6.16;6.79;7.33;7.96;8.51;9.15;9.81;10.4;10.85;12.14;13.37;14.1;14.87;15.48;16.42&
            &;17.3;17.8;18.88;19.39;19.86;20;20.54;20.97;21.45;22.25;22.77;15.38;8.89" // &
            new_line('a') // "160;0;4.09;4.41;4.83;5.77;6.39;6.94;7.55;8.04;8.67;9.28;9.83;10.24;11.46;12.69;13.39;14.11;14.73;15.6&
            &;16.41;16.87;17.85;18.4;18.97;19.15;19.72;20.2;20.65;21.35;21.84;14.95;8.74" // &
            new_line('a') // "162;0;4;4.29;4.69;5.62;6.23;6.77;7.38;7.86;8.48;9.07;9.6;10;11.18;12.42;13.1;13.81;14.43;15.27;16.06;&
            &16.5;17.43;18;18.62;18.81;19.39;19.89;20.33;20.99;21.48;14.76;8.61" // &
            new_line('a') // "168;0;3.74;3.93;4.35;5.15;5.75;6.31;6.93;7.34;7.92;8.45;8.95;9.35;10.44;11.68;12.32;12.99;13.63;14.39&
            &;15.11;15.5;16.31;16.94;17.7;17.92;18.53;19.08;19.49;19.99;20.46;14.34;8.3" // &
            new_line('a') // "170;0;3.69;3.85;4.27;5.04;5.65;6.22;6.82;7.23;7.8;8.31;8.8;9.22;10.27;11.51;12.15;12.81;13.45;14.19;1&
            &4.9;15.28;16.06;16.7;17.51;17.73;18.34;18.91;19.31;19.77;20.22;14.24;8.24" // &
            new_line('a') // "174;0;3.57;3.69;4.11;4.83;5.43;6.01;6.62;7;7.55;8.03;8.5;8.93;9.95;11.19;11.81;12.45;13.11;13.81;14.4&
            &8;14.84;15.57;16.24;17.11;17.35;17.98;18.57;18.95;19.33;19.77;14.03;8.13" // &
            new_line('a') // "180;0;3.51;3.6;4.03;4.71;5.31;5.91;6.51;6.88;7.41;7.88;8.33;8.79;9.78;11.02;11.63;12.26;12.93;13.61;1&
            &4.26;14.61;15.31;15.99;16.9;17.15;17.79;18.39;18.77;19.09;19.52;13.87;8.07"

      call split_lines(polar_csv, lines, nlines)
      call split_tokens(lines(1), ';', tokens, ntok)

      nwinds = ntok - 1
      allocate(winds(nwinds))
      do i = 1, nwinds
         read(tokens(i + 1), *, iostat=ios) winds(i)
      end do

      ndegrees = nlines - 1
      allocate(degrees(ndegrees), speeds(ndegrees, nwinds))

      do i = 2, nlines
         call split_tokens(lines(i), ';', tokens, ntok)
         read(tokens(1), *) degrees(i - 1)
         do j = 1, nwinds
            read(tokens(j + 1), *) speeds(i - 1, j)
         end do
      end do
   end subroutine read_polar_data

   subroutine split_lines(str, lines, n)
      character(*), intent(in) :: str
      character(*), intent(out) :: lines(:)
      integer, intent(out) :: n
      integer :: i, j, k

      n = 0
      k = 1
      do i = 1, len_trim(str)
         if (str(i:i) == char(10)) then
            n = n + 1
            lines(n) = str(k:i - 1)
            k = i + 1
         end if
      end do
      if (k <= len_trim(str)) then
         n = n + 1
         lines(n) = str(k:)
      end if
   end subroutine split_lines

   subroutine split_tokens(str, sep, tokens, n)
      character(*), intent(in) :: str
      character, intent(in) :: sep
      character(*), intent(out) :: tokens(:)
      integer, intent(out) :: n
      integer :: i, k

      n = 0
      k = 1
      do i = 1, len_trim(str)
         if (str(i:i) == sep) then
            n = n + 1
            tokens(n) = str(k:i - 1)
            k = i + 1
         end if
      end do
      if (k <= len_trim(str)) then
         n = n + 1
         tokens(n) = str(k:)
      end if
   end subroutine split_tokens

   subroutine init_chart()
      chart(1) = '...S.....'
      chart(2) = 'x......x.'
      chart(3) = '....x..x.'
      chart(4) = 'x...xx.x.'
      chart(5) = 'x...xx.x.'
      chart(6) = '..xxxx.xx'
      chart(7) = 'x..xxx...'
      chart(8) = '.......xx'
      chart(9) = 'x..F..x.x'
   end subroutine init_chart

   subroutine init_slices()
      integer :: s, i, j
      real(kind=dp) :: lat, lon
      type(surface_params) :: surf

      allocate(slices(200, 9, 9))

      do s = 1, 200
         do i = 1, 9
            lat = 19.78_dp - 2.0_dp / 60.0_dp + real(i, dp) / 60.0_dp
            do j = 1, 9
               lon = -155.0_dp - 6.0_dp / 60.0_dp + real(j, dp) / 60.0_dp
               slices(s, i, j)%pt%lat = lat
               slices(s, i, j)%pt%lon = lon
               surf = surfacebylongitude(lon)
               surf%windvelocity = surf%windvelocity * (1.0_dp + 0.002_dp * s)
               slices(s, i, j)%surf = surf
            end do
         end do
      end do
   end subroutine init_slices

   function surfacebylongitude(lon) result(surf)
      real(kind=dp), intent(in) :: lon
      type(surface_params) :: surf

      if (lon < -155.03_dp) then
         surf = surface_params(-5.0_dp, 8.0_dp, 150.0_dp, 0.5_dp)
      else if (lon < -155.99_dp) then
         surf = surface_params(-90.0_dp, 20.0_dp, 150.0_dp, 0.4_dp)
      else
         surf = surface_params(180.0_dp, 25.0_dp, 150.0_dp, 0.3_dp)
      end if
   end function surfacebylongitude

   elemental function deg2rad(deg) result(rad)
      real(kind=dp), intent(in) :: deg
      real(kind=dp) :: rad
      rad = modulo(deg * pi / 180.0_dp, 2.0_dp * pi)
   end function deg2rad

   elemental function rad2deg(rad) result(deg)
      real(kind=dp), intent(in) :: rad
      real(kind=dp) :: deg
      deg = modulo(rad * 180.0_dp / pi, 360.0_dp)
   end function rad2deg

   elemental function sind(deg) result(s)
      real(kind=dp), intent(in) :: deg
      real(kind=dp) :: s
      s = sin(deg2rad(deg))
   end function sind

   elemental function cosd(deg) result(c)
      real(kind=dp), intent(in) :: deg
      real(kind=dp) :: c
      c = cos(deg2rad(deg))
   end function cosd

   elemental function asind(x) result(deg)
      real(kind=dp), intent(in) :: x
      real(kind=dp) :: deg
      deg = rad2deg(asin(x))
   end function asind

   function atand2(y, x) result(deg)
      real(kind=dp), intent(in) :: y, x
      real(kind=dp) :: deg
      deg = rad2deg(atan2(y, x))
   end function atand2

   subroutine haversine(lat1, lon1, lat2, lon2, distance, theta)
      real(kind=dp), intent(in) :: lat1, lon1, lat2, lon2
      real(kind=dp), intent(out) :: distance, theta
      real(kind=dp) :: dlat, dlon, a, c

      dlat = lat2 - lat1
      dlon = lon2 - lon1
      a = sind(dlat / 2.0_dp)**2 + cosd(lat1) * cosd(lat2) * sind(dlon / 2.0_dp)**2
      c = 2.0_dp * asind(sqrt(a))
      theta = atand2(sind(dlon) * cosd(lat2), &
            cosd(lat1) * sind(lat2) - sind(lat1) * cosd(lat2) * cosd(dlon))
      theta = modulo(theta, 360.0_dp)
      distance = r * c * 0.5399565_dp
   end subroutine haversine

   subroutine find_range(v, arr, lo, hi)
      real(kind=dp), intent(in) :: v, arr(:)
      integer, intent(out) :: lo, hi
      integer :: i, n

      n = size(arr)
      lo = -1
      hi = -1

      do i = 1, n
         if (arr(i) >= v) then
            lo = i
            exit
         end if
      end do

      if (lo > 0) then
         do i = n, 1, -1
            if (arr(i) <= v) then
               hi = i
               exit
            end if
         end do
      end if
   end subroutine find_range

   function boatspeed(pointofsail, windspeed) result(speed)
      real(kind=dp), intent(in) :: pointofsail, windspeed
      real(kind=dp) :: speed
      integer :: ld, ud, lv, uv
      real(kind=dp) :: wu, wl, du, dl, f, su, sl

      call find_range(pointofsail, degrees, ld, ud)
      call find_range(windspeed, winds, lv, uv)

      if (ld == -1 .or. ud == -1 .or. lv == -1 .or. uv == -1) then
         speed = -1.0_dp
         return
      end if

      wu = winds(uv)
      wl = winds(lv)
      du = degrees(ud)
      dl = degrees(ld)

      if (ld == ud) then
         if (uv == lv) then
            f = 1.0_dp
         else
            f = (wu - windspeed) / (wu - wl)
         end if
      else if (uv == lv) then
         f = (du - pointofsail) / (du - dl)
      else
         f = ((du - pointofsail) / (du - dl) + (wu - windspeed) / (wu - wl)) / 2.0_dp
      end if

      su = speeds(ud, uv)
      sl = speeds(ld, lv)
      speed = su - f * (su - sl)
   end function boatspeed

   function sailingspeed(azimuth, pointofsail, ws) result(speed)
      real(kind=dp), intent(in) :: azimuth, pointofsail, ws
      real(kind=dp) :: speed
      speed = boatspeed(pointofsail, ws) * cosd(abs(pointofsail - azimuth))
   end function sailingspeed

   function bestvectorspeed(dirtravel, surf) result(vmg)
      real(kind=dp), intent(in) :: dirtravel
      type(surface_params), intent(in) :: surf
      real(kind=dp) :: vmg
      real(kind=dp) :: azimuth, other, ss, dirchosen, dircurrent, wx, wy, curx, cury
      integer :: i, idx

      azimuth = modulo(dirtravel - surf%winddirection, 360.0_dp)
      if (azimuth > 180.0_dp) azimuth = 360.0_dp - azimuth

      vmg = boatspeed(azimuth, surf%windvelocity)
      other = -1.0_dp
      idx = -1

      do i = 1, ndegrees
         ss = sailingspeed(azimuth, degrees(i), surf%windvelocity)
         if (ss > other) then
            other = ss
            idx = i
         end if
      end do

      if (other > vmg) then
         azimuth = degrees(idx)
         vmg = other
      end if

      dirchosen = deg2rad(surf%winddirection + azimuth)
      dircurrent = deg2rad(surf%currentdirection)
      wx = vmg * sin(dirchosen)
      wy = vmg * cos(dirchosen)
      curx = surf%currentvelocity * sin(dircurrent)
      cury = surf%currentvelocity * cos(dircurrent)

      vmg = sqrt((wx + curx)**2 + (wy + cury)**2)
   end function bestvectorspeed

   function sailsegmenttime(surf, lat1, lon1, lat2, lon2) result(ttime)
      type(surface_params), intent(in) :: surf
      real(kind=dp), intent(in) :: lat1, lon1, lat2, lon2
      real(kind=dp) :: ttime
      real(kind=dp) :: distance, direction, velocity

      call haversine(lat1, lon1, lat2, lon2, distance, direction)
      velocity = bestvectorspeed(direction, surf)
      ttime = (1.0_dp / 60.0_dp) * distance / (velocity * 1.94384_dp)
   end function sailsegmenttime

   subroutine find_route(path, pathlen, durstr, timestr)
      integer, intent(out) :: path(:, :), pathlen
      character(*), intent(out) :: durstr, timestr
      integer :: todo(2, 100), ntodo, px, py, nx, ny, sdx, i, j
      real(kind=dp) :: costs(9, 9), duration, nt, lat1, lon1, lat2, lon2
      integer :: paths(2, 9, 9)
      real(kind=dp) :: mintime, t0, elapsed_time
      type(surface_params) :: surf

      call cpu_time(t0)
      costs = -1.0_dp
      paths = 0
      mintime = 1000.0_dp

      py = 1
      px = 4
      todo(:, 1) = [py, px]
      ntodo = 1
      costs(py, px) = 0.0_dp

      do while (ntodo > 0)
         py = todo(1, 1)
         px = todo(2, 1)
         todo(:, 1:ntodo - 1) = todo(:, 2:ntodo)
         ntodo = ntodo - 1

         duration = costs(py, px)
         sdx = mod(int(duration) / timeinterval, 200) + 1

         do nx = px - 1, px + 1
            do ny = py - 1, py + 1
               if ((nx /= px .or. ny /= py) .and. &
                     nx >= 1 .and. nx <= 9 .and. &
                     ny >= 1 .and. ny <= 9) then
                  if (chart(ny)(nx:nx) /= 'x') then

                     lat1 = slices(sdx, py, px)%pt%lat
                     lon1 = slices(sdx, py, px)%pt%lon
                     lat2 = slices(sdx, ny, nx)%pt%lat
                     lon2 = slices(sdx, ny, nx)%pt%lon
                     surf = slices(sdx, py, px)%surf

                     nt = duration + sailsegmenttime(surf, lat1, lon1, lat2, lon2)

                     if (costs(ny, nx) < 0.0_dp .or. nt < costs(ny, nx)) then
                        costs(ny, nx) = nt
                        paths(1, ny, nx) = py
                        paths(2, ny, nx) = px

                        if (.not.any(todo(1, 1:ntodo) == ny .and. todo(2, 1:ntodo) == nx)) then
                           ntodo = ntodo + 1
                           todo(1, ntodo) = ny
                           todo(2, ntodo) = nx
                        end if
                     end if
                  end if
               end if
            end do
         end do
      end do

      py = 9
      px = 4
      mintime = costs(py, px)
      pathlen = 1
      path(1, pathlen) = py
      path(2, pathlen) = px

      block
         integer :: nextpy, nextpx

         do while (.true.)
            nextpy = paths(1, py, px)
            nextpx = paths(2, py, px)
            if (nextpy == 0) exit
            pathlen = pathlen + 1
            py = nextpy
            px = nextpx
            path(1, pathlen) = py
            path(2, pathlen) = px
         end do
      end block

      do i = 1, pathlen / 2
         j = pathlen - i + 1
         call swap(path(:, i), path(:, j))
      end do

      call cpu_time(elapsed_time)
      call format_time(mintime * 60.0_dp, durstr)
      call format_time(elapsed_time - t0, timestr)
   end subroutine find_route

   subroutine swap(a, b)
      integer, intent(inout) :: a(2), b(2)
      integer :: t(2)
      t = a
      a = b
      b = t
   end subroutine swap

   subroutine format_time(seconds, str)
      real(kind=dp), intent(in) :: seconds
      character(*), intent(out) :: str
      integer :: h, m, s

      h = int(seconds / 3600.0_dp)
      m = int(mod(seconds, 3600.0_dp) / 60.0_dp)
      s = int(mod(seconds, 60.0_dp))

      if (h > 0) then
         write(str, '(i0,"h ",i0,"m ",i0,"s")') h, m, s
      else if (m > 0) then
         write(str, '(i0,"m ",i0,"s")') m, s
      else
         write(str, '(i0,"s")') s
      end if
   end subroutine format_time

   subroutine print_results(path, pathlen, durstr, timestr)
      integer, intent(in) :: path(:, :), pathlen
      character(*), intent(in) :: durstr, timestr
      integer :: i

      write(*, '(a)') ''
      write(*, '(a)') 'The route taking the least time found was:'
      write(*, '(a)', advance='no') '    ['
      do i = 1, pathlen
         if (i > 1) write(*, '(a)', advance='no') ', '
         write(*, '(a,i0,a,i0,a)', advance='no') '[', path(1, i), ',', path(2, i), ']'
      end do
      write(*, '(a)') ']'
      write(*, '(a,a,a,a,a)') 'which has duration ', trim(durstr), ' [route found in ', trim(timestr), ']'
   end subroutine print_results

end program weather_routing

