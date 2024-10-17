(
        []INT a = (-1 , -2 , 3 , 5 , 6 , -2 , -1 , 4 , -4 , 2 , -1);

        INT begin max, end max, max sum, sum;

        sum := 0;
        begin max := 0;
        end max := -1;
        max sum := 0;


        FOR begin FROM LWB a TO UPB a DO
                sum := 0;
                FOR end FROM begin TO UPB a DO
                        sum +:= a[end];
                        IF sum > max sum THEN
                                max sum := sum;
                                begin max := begin;
                                end max := end
                        FI
                OD
        OD;

        FOR i FROM begin max TO end max DO
                print((" ",whole(a[i],0)))
        OD

)
