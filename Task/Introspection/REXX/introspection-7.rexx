if testxyz()  then say 'function XYZ not found.'
              else say 'function XYZ was found.'
exit
/*──────────────────────────────────────────────────────────────────────────────────────*/
testxyz: signal on syntax
         call XYZ
         return 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
syntax:  return 1
