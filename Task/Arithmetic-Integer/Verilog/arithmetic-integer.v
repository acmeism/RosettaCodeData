module main;
  integer a, b;
  integer suma, resta, producto;
  integer division, resto, expo;

  initial begin
    a = -12;
    b = 7;

    suma = a + b;
    resta = a - b;
    producto = a * b;
    division = a / b;
    resto = a % b;
    expo = a ** b;

    $display("Siendo dos enteros a = -12 y b = 7");
    $display("       suma de a + b = ", suma);
    $display("      resta de a - b = ", resta);
    $display("   producto de a * b = ", producto);
    $display("   división de a / b = ", division);
    $display("   resto de a mod  b = ", resto);
    $display("exponenciación a ^ b = ", expo);
    $finish ;
  end
endmodule
