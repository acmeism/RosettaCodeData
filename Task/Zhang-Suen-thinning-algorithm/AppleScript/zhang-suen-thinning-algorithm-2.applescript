on demo()
    set pattern to "
 #################                   #############
 ##################               ################
 ###################            ##################
 ########     #######          ###################
   ######     #######         #######       ######
   ######     #######        #######
   #################         #######
   ################          #######
   #################         #######
   ######     #######        #######
   ######     #######        #######
   ######     #######         #######       ######
 ########     #######          ###################
 ########     ####### ######    ################## ######
 ########     ####### ######      ################ ######
 ########     ####### ######         ############# ######
                                                           "
    set matrix to pattern's paragraphs
    repeat with thisRow in matrix
        set thisRow's contents to thisRow's characters
    end repeat
    ZhangSuen(matrix, {black:"#", white:space})
    repeat with thisRow in matrix
        set thisRow's contents to join(thisRow, "")
    end repeat
    return join(matrix, linefeed)
end demo
return demo()
