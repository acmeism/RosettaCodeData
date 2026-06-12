       identification division.
       program-id. nbody.
       environment division.
       configuration section.
       source-computer.
           System76
                  with debugging mode
           .
       repository.
           function all intrinsic.
       input-output section.
       file-control.
           select input-file assign to "nbody-file"
                  line sequential.
       data division.
       file section.
       fd  input-file.
       01  input-record        pic x(31).
       01  input-rec-constant.
           05 i-r-gravconstant pic 9.9999.
           05 filler           pic x.
           05 i-r-bodies       pic 9(03).
           05 filler           pic x.
           05 i-r-timesteps    pic 9(03).
           05 filler           pic x(17).
       01  input-rec-mass.
           05  i-r-mass        pic 9.9999.
           05  filler          pic x(25).
       01  input-rec-pos.
           05 i-r-posx         pic -9.9999.
           05 filler           pic x.
           05 i-r-posy         pic -9.9999.
           05 filler           pic x.
           05 i-r-posz         pic -9.9999.
           05 filler           pic x(08).
       01  input-rec-vol.
           05 i-r-volx         pic -9.9999.
           05 filler           pic x(01).
           05 i-r-voly         pic -9.9999.
           05 filler           pic x(01).
           05 i-r-volz         pic -9.9999.
           05 filler           pic x(08).


       working-storage section.
       77  bodies       pic 9(3).
       77  timesteps    pic 9(3).
       77  gravconstant pic 9v999999.
       77  i            pic 999.
       77  idis         pic 9.
       77  j            pic 999.
       77  t            pic 999.
       77  tdis         pic z9.
       77  c            pic 999.
       77  dx           pic s9(9)v9(20).
       77  dy           pic s9(9)v9(20).
       77  dz           pic s9(9)v9(20).
       77  distance     pic s9(9)v9(20).
       77  force        pic s9(9)v9(20).
       77  temp-vx      pic s9(9)v9(20).
       77  temp-vy      pic s9(9)v9(20).
       77  temp-vz      pic s9(9)v9(20).

       01  masses.
           05  mass occurs 10 times pic 9v9999.
       01  positions.
           05  posn occurs 10 times.
               10  x pic s9(9)v9(20).
               10  y pic s9(9)v9(20).
               10  z pic s9(9)v9(20).
               10  xx pic s9v9(06).
               10  yy pic s9v9(06).
               10  zz pic s9v9(06).
       01  velocities.
           05  velocity occurs 10 times.
               10  vx pic s9(9)v9(20).
               10  vy pic s9(9)v9(20).
               10  vz pic s9(9)v9(20).
               10  vxx pic s9v9(06).
               10  vyy pic s9v9(06).
               10  vzz pic s9v9(06).
       01  accelerations.
           05  acceleration occurs 10 times.
               10  ax pic s9(9)v9(20).
               10  ay pic s9(9)v9(20).
               10  az pic s9(9)v9(20).

       procedure division.
       main-procedure.
           open input input-file
           read input-file into input-rec-constant
           move i-r-gravconstant to gravconstant
           move i-r-bodies       to bodies
           move i-r-timesteps    to timesteps

           perform initiate-system
           perform simulate

           close input-file
           stop run
           .

       initiate-system.
           perform varying i from 1 by 1 until i > bodies
               read input-file into input-rec-mass
               move i-r-mass to mass(i)
               read input-file into input-rec-pos
               move i-r-posx to x(i)
               move i-r-posy to y(i)
               move i-r-posz to z(i)
               read input-file into input-rec-vol
               move i-r-volx to vx(i)
               move i-r-voly to vy(i)
               move i-r-volz to vz(i)
           end-perform
           .

       simulate.
           perform display-topline
           perform varying t from 1 by 1 until t > timesteps
               perform compute-accelerations
               perform compute-positions
               perform compute-velocities
               perform resolve-collisions
               perform round-results
               perform display-results
           end-perform
           .

       compute-accelerations.
           perform varying i from 1 by 1 until i > bodies
               move 0 to ax(i) ay(i) az(i)
               perform varying j from 1 by 1 until j > bodies
                   if i not equal to j
                       compute dx rounded = x(j) - x(i)
                       compute dy rounded = y(j) - y(i)
                       compute dz rounded = z(j) - z(i)
                       compute distance rounded =
                                sqrt(dx * dx + dy * dy + dz * dz)
                       compute force rounded = gravconstant * mass(j)
                                / (distance * distance * distance)
                       compute ax(i) rounded = ax(i) + force * dx
                       compute ay(i) rounded = ay(i) + force * dy
                       compute az(i) rounded = az(i) + force * dz
                   end-if
               end-perform
           end-perform
           .

       compute-velocities.
           perform varying i from 1 by 1 until i > bodies
               compute vx(i) = vx(i) + ax(i)
               compute vy(i) = vy(i) + ay(i)
               compute vz(i) = vz(i) + az(i)
           end-perform
           .

       compute-positions.
           perform varying i from 1 by 1 until i > bodies
               compute  x(i) = x(i) + vx(i) + 0.5 * ax(i)
               compute  y(i) = y(i) + vy(i) + 0.5 * ay(i)
               compute  z(i) = z(i) + vz(i) + 0.5 * az(i)
           end-perform
           .

       resolve-collisions.
           perform varying i from 1 by 1 until i > bodies - 1
               perform varying j from 1 by 1 until j > bodies
                   if x(i) = x(j) and y(i) = y(j) and z(i) = z(j)
                       move vx(i) to temp-vx
                       move vy(i) to temp-vy
                       move vz(i) to temp-vz
                       move vx(j) to vx(i)
                       move vy(j) to vy(i)
                       move vz(j) to vz(i)
                       move temp-vx to vx(j)
                       move temp-vy to vy(j)
                       move temp-vz to vz(j)
                   end-if
               end-perform
           end-perform
           .

       round-results.
           perform varying i from 1 by 1 until i > bodies
               compute  xx(i) rounded = x(i)
               compute  yy(i) rounded = y(i)
               compute  zz(i) rounded = z(i)
               compute  vxx(i) rounded = vx(i)
               compute  vyy(i) rounded = vy(i)
               compute  vzz(i) rounded = vz(i)
           end-perform
           .

       display-topline.
           display "Body   :      X         Y         Z    |"
                   "      VX        VY        VZ  "
           .

       display-results.
           move t to tdis
           display "Cycle " tdis
           perform varying i from 1 by 1 until i > bodies
               move i to idis
               display "Body " idis " : " xx(i) " " yy(i) " "
                        zz(i) " | " vxx(i) " " vyy(i) " " vzz(i)
           end-perform
           display " "
           .
