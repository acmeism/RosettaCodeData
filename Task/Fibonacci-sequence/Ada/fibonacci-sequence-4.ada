with ada.text_io;
use  ada.text_io;

procedure fast_fibo is
	-- We work with biggest natural integers in a 64 bits machine
	type Big_Int is mod 2**64;

	-- We provide an index type for accessing the fibonacci sequence terms
	type Index is new Big_Int;

	-- fibo is a generic function that needs a modulus type since it will return
	-- the n'th term of the fibonacci sequence modulus this type (use Big_Int to get the	
	-- expected behaviour in this particular task)
	generic
		type ring_element is mod <>;
		with function "*" (a, b : ring_element) return ring_element is <>;
		function fibo (n : Index) return ring_element;
	function fibo (n : Index) return ring_element is

		type matrix is array (1 .. 2, 1 .. 2) of ring_element;

		-- f is the matrix you apply to a column containing (F_n, F_{n+1}) to get
		-- the next one containing (F_{n+1},F_{n+2})
		-- could be a more general matrix (given as a generic parameter) to deal with
		-- other linear sequences of order 2
		f : constant matrix := (1 => (0, 1), 2 => (1, 1));

		function "*" (a, b : matrix) return matrix is
		(1 => (a(1,1)*b(1,1)+a(1,2)*b(2,1), a(1,1)*b(1,2)+a(1,2)*b(2,2)),
		 2 => (a(2,1)*b(1,1)+a(2,2)*b(2,1), a(2,1)*b(1,2)+a(2,2)*b(2,2)));

		function square (m : matrix) return matrix is (m * m);

		-- Fast_Pow could be non recursive but it doesn't really matter since
		-- the number of calls is bounded up by the size (in bits) of Big_Int (e.g 64)
		function fast_pow (m : matrix; n : Index) return matrix is
		(if n = 0 then (1 => (1, 0), 2 => (0, 1)) -- = identity matrix
		 elsif n mod 2 = 0 then square (fast_pow (m, n / 2))
		 else m * square (fast_pow (m, n / 2)));

	begin
		return fast_pow (f, n)(2, 1);
	end fibo;

	function Big_Int_Fibo is new fibo (Big_Int);
begin
	-- calculate instantly F_n with n=10^15 (modulus 2^64 )
	put_line (Big_Int_Fibo (10**15)'img);
end fast_fibo;
