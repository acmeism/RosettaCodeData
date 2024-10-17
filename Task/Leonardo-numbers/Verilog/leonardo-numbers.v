module leonardo #(parameter LIMIT = 25) (
    input [31:0] L0, L1, suma,
    input [8*8:1] texto
);
    integer i;
    reg [31:0] tmp, l0, l1;
    initial begin
        l0 = L0;
        l1 = L1;
        $display("Numeros de %0s (%0d, %0d, %0d):", texto, L0, L1, suma);
        for (i = 1; i <= LIMIT; i = i + 1) begin
            if (i == 1)
                $write("%0d ", l0);
            else if (i == 2)
                $write("%0d ", l1);
            else begin
                $write("%0d ", l0 + l1 + suma);
                tmp = l0;
                l0 = l1;
                l1 = tmp + l1 + suma;
            end
        end
        $display("");
    end
endmodule

module main;
    reg [8*8:1] texto1 = "Leonardo";
    reg [63:0] texto2 = "Fibonacci";
    leonardo #(25) leo1(1, 1, 1, texto1);
    leonardo #(25) fibo(0, 1, 0, texto2);
endmodule
