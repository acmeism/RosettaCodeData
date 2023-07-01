def jq:
"\("
                     #
                #
               #     #   ###
              #      #  #   #
             #       #  #   #
        #   #    #   #   ####
           #      ###       #
                            #
")";

def banner3D:
  jq | split("\n") | map( gsub("#"; "╔╗") | gsub(" "; "  ") )
  | [[range(length;0;-1) | " " * .], . ] | transpose[] | join("") ;

banner3D
