///////////////////////////////////////////////////////////////////////////////
/// seven_sided_dice_tb : (testbench)                                       ///
///      Check the distribution of the output of a seven sided dice circuit ///
///////////////////////////////////////////////////////////////////////////////
module seven_sided_dice_tb;
  reg [31:0] freq[0:6];
  reg        clk;
  wire [2:0] dice_face;
  reg        req;
  wire       valid_roll;
  integer    i;
  initial begin
    clk <= 0;
    forever begin
       #1;
       clk <= ~clk;
    end
  end
  initial begin
    req <= 1'b1;
    for(i = 0; i < 7; i = i + 1) begin
      freq[i] <= 32'b0;
    end
    repeat(10) @(posedge clk);
    repeat(7000000) begin
      @(posedge clk);
      while(~valid_roll) begin
        @(posedge clk);
      end
      freq[dice_face] <= freq[dice_face] + 32'b1;
    end
    $display("********************************************");
    $display("*** Seven sided dice distribution:          ");
    $display("    Theoretical distribution is an uniform  ");
    $display("    distribution with (1/7)-probability     ");
    $display("    for each possible outcome,              ");
    $display("  The experimental distribution is:          ");
    for(i = 0; i < 7; i = i + 1) begin
      if(freq[i] < 32'd1_000_000) begin
        $display("%d with probability 1/7 - (%d ppm)", i, (32'd1_000_000 - freq[i])/7);
      end
      else begin
        $display("%d with probability 1/7 + (%d ppm)", i, (freq[i] - 32'd1_000_000)/7);
      end
    end
    $finish;
  end

  seven_sided_dice DUT(
    .clk(clk),
    .req(req),
    .valid_roll(valid_roll),
    .dice_face(dice_face)
  );
endmodule
///////////////////////////////////////////////////////////////////////////////
/// seven_sided_dice :                                                      ///
///      Synthsizeable module that using a 5 sided dice as a black box      ///
///      is able to reproduce teh outcomes if a 7-sided dice                ///
///////////////////////////////////////////////////////////////////////////////
module seven_sided_dice(
  input wire       clk,
  input wire       req,
  output reg       valid_roll,
  output reg [2:0] dice_face
);
  wire [2:0] face1;
  wire [2:0] face2;
  reg [4:0] combination;
  reg req_p1;
  reg req_p2;
  reg req_p3;
  always @(posedge clk) begin
    req_p1 <= req;
    req_p2 <= req_p1;
  end
  always @(posedge clk) begin
    if(req_p1) begin
      combination <= face1 + face2 + {face2, 2'b00};
    end
    if(req_p2) begin
      case(combination)
           5'd0,  5'd1,  5'd2: {valid_roll, dice_face} <= {1'b1, 3'd0};
           5'd3,  5'd4,  5'd5: {valid_roll, dice_face} <= {1'b1, 3'd1};
           5'd6,  5'd7,  5'd8: {valid_roll, dice_face} <= {1'b1, 3'd2};
           5'd9, 5'd10, 5'd11: {valid_roll, dice_face} <= {1'b1, 3'd3};
          5'd12, 5'd13, 5'd14: {valid_roll, dice_face} <= {1'b1, 3'd4};
          5'd15, 5'd16, 5'd17: {valid_roll, dice_face} <= {1'b1, 3'd5};
          5'd18, 5'd19, 5'd20: {valid_roll, dice_face} <= {1'b1, 3'd6};
          default: valid_roll <= 1'b0;
      endcase
    end
  end

  five_sided_dice dice1(
    .clk(clk),
    .req(req),
    .dice_face(face1)
  );

  five_sided_dice dice2(
    .clk(clk),
    .req(req),
    .dice_face(face2)
  );
endmodule

///////////////////////////////////////////////////////////////////////////////
/// five_sided_dice :                                                       ///
///      A model of the five sided dice component                           ///
///////////////////////////////////////////////////////////////////////////////
module five_sided_dice(
  input wire clk,
  input wire req,
  output reg [2:0] dice_face
);
  always @(posedge clk) begin
    if(req) begin
      dice_face  <= $urandom % 5;
    end
  end
endmodule
