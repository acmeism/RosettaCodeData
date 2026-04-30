class Main {
	static public function main():Void {
        var input_a = Sys.stdin().readLine();
        var input_b = Sys.stdin().readLine();

        var a = Std.parseInt(input_a);
        var b = Std.parseInt(input_b);

        trace(a + b);
        trace(a - b);
        trace(a * b);
        trace(Std.int(a / b));
        trace(a % b);
        trace(Math.pow(a, b));
    }
}
