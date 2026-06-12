program Perceptron;

(*
 * implements a version of the algorithm set out at
 * http://natureofcode.com/book/chapter-10-neural-networks/ ,
 * but without graphics
 *)

function targetOutput( a, b : integer ) : integer;
(* the function the perceptron will be learning is f(x) = 2x + 1 *)
begin
    if a * 2 + 1 < b then
        targetOutput := 1
    else
        targetOutput := -1
end;

procedure showTargetOutput;
var x, y : integer;
begin
    for y := 10 downto -9 do
    begin
        for x := -9 to 10 do
            if targetOutput( x, y ) = 1 then
                write( '#' )
            else
                write( 'O' );
        writeln
    end;
    writeln
end;

procedure randomWeights( var ws : array of real );
(* start with random weights -- NB pass by reference *)
var i : integer;
begin
    randomize; (* seed random-number generator *)
    for i := 0 to 2 do
        ws[i] := random * 2 - 1
end;

function feedForward( ins : array of integer; ws : array of real ) : integer;
(* the perceptron outputs 1 if the sum of its inputs multiplied by
its input weights is positive, otherwise -1 *)
var sum : real;
    i : integer;
begin
    sum := 0;
    for i := 0 to 2 do
        sum := sum + ins[i] * ws[i];
    if sum > 0 then
        feedForward := 1
    else
        feedForward := -1
end;

procedure showOutput( ws : array of real );
var inputs : array[0..2] of integer;
    x, y : integer;
begin
    inputs[2] := 1; (* bias *)
    for y := 10 downto -9 do
    begin
        for x := -9 to 10 do
        begin
            inputs[0] := x;
            inputs[1] := y;
            if feedForward( inputs, ws ) = 1 then
                write( '#' )
            else
                write( 'O' )
        end;
        writeln
    end;
    writeln
end;

procedure train( var ws : array of real; runs : integer );
(* pass the array of weights by reference so it can be modified *)
var inputs : array[0..2] of integer;
    error : real;
    x, y, i, j : integer;
begin
    inputs[2] := 1; (* bias *)
    for i := 1 to runs do
    begin
        for y := 10 downto -9 do
        begin
            for x := -9 to 10 do
            begin
                inputs[0] := x;
                inputs[1] := y;
                error := targetOutput( x, y ) - feedForward( inputs, ws );
                for j := 0 to 2 do
                    ws[j] := ws[j] + error * inputs[j] * 0.01;
                    (* 0.01 is the learning constant *)
            end;
        end;
    end;
end;

var weights : array[0..2] of real;

begin
    writeln( 'Target output for the function f(x) = 2x + 1:' );
    showTargetOutput;
    randomWeights( weights );
    writeln( 'Output from untrained perceptron:' );
    showOutput( weights );
    train( weights, 1 );
    writeln( 'Output from perceptron after 1 training run:' );
    showOutput( weights );
    train( weights, 4 );
    writeln( 'Output from perceptron after 5 training runs:' );
    showOutput( weights )
end.
