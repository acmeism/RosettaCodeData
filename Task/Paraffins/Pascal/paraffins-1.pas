Program Paraffins;

uses
  gmp;

const
  max_n = 500;
  branch = 4;

var
  rooted, unrooted: array [0 .. max_n-1] of mpz_t;
  c: array [0 .. branch-1] of mpz_t;
  cnt, tmp: mpz_t;
  n: integer;
  fmt: pchar;
  sum: integer;

procedure tree(br, n, l: integer; sum: integer; cnt: mpz_t);
  var
    b, m: integer;
  begin
    for b := br + 1 to branch do
    begin
      sum := sum + n;
      if sum >= max_n then
	exit;

      (* prevent unneeded long math *)
      if (l * 2 >= sum) and (b >= branch) then
	exit;

      if b = (br + 1) then
	mpz_mul(c[br], rooted[n], cnt)
      else
      begin
	mpz_add_ui(tmp, rooted[n], b - br - 1);
	mpz_mul(c[br], c[br], tmp);
	mpz_divexact_ui(c[br], c[br], b - br);
      end;

      if l * 2 < sum then
	mpz_add(unrooted[sum], unrooted[sum], c[br]);

      if b < branch then
      begin
	mpz_add(rooted[sum], rooted[sum], c[br]);
	for m := n-1 downto 1 do
	  tree(b, m, l, sum, c[br]);
      end;
    end;
  end;

procedure bicenter(s: integer);
begin
  if odd(s) then
    exit;
  mpz_add_ui(tmp, rooted[s div 2], 1);
  mpz_mul(tmp, rooted[s div 2], tmp);
  mpz_tdiv_q_2exp(tmp, tmp, 1);

  mpz_add(unrooted[s], unrooted[s], tmp);
end;

begin
  for n := 0 to 1 do
  begin
    mpz_init_set_ui(rooted[n], 1);
    mpz_init_set_ui(unrooted[n], 1);
  end;
  for n := 2 to max_n-1 do
  begin
    mpz_init_set_ui(rooted[n], 0);
    mpz_init_set_ui(unrooted[n], 0);
  end;
  for n := 0 to BRANCH-1 do
    mpz_init(c[n]);

  mpz_init(tmp);

  mpz_init_set_ui(cnt, 1);
  sum := 1;
  for n := 1 to MAX_N do
  begin
    tree(0, n, n, sum, cnt);
    bicenter(n);
    mp_printf('%d: %Zd'+chr(13)+chr(10), n, @unrooted[n]);
  end;
end.
