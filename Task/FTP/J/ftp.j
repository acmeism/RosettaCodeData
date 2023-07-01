   require 'web/gethttp'
   gethttp 'ftp://anonymous:example@ftp.hq.nasa.gov/pub/issoutreach/Living%20in%20Space%20Stories%20(MP3%20Files)/'
-rw-rw-r--   1 109      space-station  2327118 May  9  2005 09sept_spacepropulsion.mp3
-rw-rw-r--   1 109      space-station  1260304 May  9  2005 Can People go to Mars.mp3
-rw-rw-r--   1 109      space-station  1350270 May  9  2005 Distill some water.mp3
-rw-rw-r--   1 109      space-station  1290888 May  9  2005 Good Vibrations.mp3
-rw-rw-r--   1 109      space-station  1431834 May  9  2005 Gravity Hurts_So good.mp3
-rw-rw-r--   1 109      space-station  1072644 May  9  2005 Gravity in the Brain.mp3
-rw-rw-r--   1 109      space-station  1230594 May  9  2005 Power to the ISS.mp3
-rw-rw-r--   1 109      space-station  1309062 May  9  2005 Space Bones.mp3
-rw-rw-r--   1 109      space-station  2292715 May  9  2005 Space Power.mp3
-rw-rw-r--   1 109      space-station   772075 May  9  2005 We have a solution.mp3
-rw-rw-r--   1 109      space-station  1134654 May  9  2005 When Space Makes you Dizzy.mp3
   #file=: gethttp rplc&(' ';'%20') 'ftp://anonymous:example@ftp.hq.nasa.gov/pub/issoutreach/Living in Space Stories (MP3 Files)/We have a solution.mp3'
772075
