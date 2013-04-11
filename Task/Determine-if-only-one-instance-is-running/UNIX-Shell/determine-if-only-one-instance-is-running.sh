# (c) Copyright 2005 Mark Hobley
#
# This is free software. This file can be redistributed or modified
# under the terms of version 1.2 of the GNU Free Documentation Licence
# as published by the Free Software Foundation.
#

 singleinstance ()
 {
   if [ -d $SRUNDIR ] ; then
     if [ -w $SRUNDIR ] ; then
       if [ -d $SRUNDIR/$APPNAME ] ; then
         echo "Process Already Running" >& 2
         return 221
       else
         mkdir $SRUNDIR/$APPNAME
         if [ "$?" -ne 0 ] ; then
           if [ -d $SRUNDIR/$APPNAME ] ; then
             echo "Process Already Running" >& 2
             return 221
           else
             echo "Unexpected Error" >& 2
             return 239
           fi
         fi
         return 0 ; # This is a unique instance
       fi
     else
       echo "Permission Denied" >& 2
       return 210
     fi
   else
     echo "Missing Directory" >& 2
     return 199
   fi
 }
