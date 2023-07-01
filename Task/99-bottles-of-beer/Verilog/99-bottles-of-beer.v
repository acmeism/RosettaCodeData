module beer;
    integer i;
    initial begin
        for (i=4; i>0; i=i-1)
        begin
            $display("%0d bottles of beer on the wall,", i);
            $display("%0d bottles of beer.", i);
            $display("Take one down and pass it around,");
            if (i==1)
                $display("no more bottles of beer on the wall...\n");
            else
                $display("%0d bottles of beer on the wall...\n", i-1);
        end
        $display("No more bottles of beer on the wall,\nno more bottles of beer.");
        $display("Go to the store and buy some more,\n 99 bottles of beer on the wall.");
    end
endmodule
