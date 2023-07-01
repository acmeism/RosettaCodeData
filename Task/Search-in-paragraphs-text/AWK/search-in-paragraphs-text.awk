awk 'BEGIN { RS = "" ; ORS = "\n----------------\n" } /Traceback/ && /SystemError/ { print substr($0,index($0,"Traceback")) }' Traceback.txt
