`timescale 1ns/10ps
`default_nettype wire

module graytestbench;

localparam aw = 8;

function [aw:0] binn_to_gray;
    input  [aw:0] binn;
begin :b2g
    binn_to_gray = binn ^ (binn >> 1);
end
endfunction

function [aw:0] gray_to_binn;
    input [aw:0] gray;
begin :g2b
    reg   [aw:0] binn;
    integer      i;

    for(i=0; i <= aw; i = i+1) begin
     binn[i] = ^(gray >> i);
    end
    gray_to_binn = binn;
end
endfunction

initial begin :test_graycode
    integer   ii;
    reg[aw:0] gray;
    reg[aw:0] binn;

    for(ii=0; ii < 10; ii=ii+1) begin
        gray = binn_to_gray(ii[aw:0]);
        binn = gray_to_binn(gray);

        $display("test_graycode: i:%x gray:%x:%b binn:%x", ii[aw:0], gray, gray, binn);
    end

    $stop;
end

endmodule

`default_nettype none
