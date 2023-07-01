module main;
    initial begin
        repeat(5) begin
            $display("Inside loop");
        end
        $display("Loop Ended");
    end
endmodule
