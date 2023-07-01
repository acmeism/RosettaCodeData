create or replace package sieve_of_eratosthenes as
  type array_of_booleans is varray(100000000) of boolean;
  type table_of_integers is table of integer;
  function find_primes (n number) return table_of_integers pipelined;
end sieve_of_eratosthenes;
/

create or replace package body sieve_of_eratosthenes as
  function find_primes (n number) return table_of_integers pipelined is
      flag array_of_booleans;
      ptr  integer;
      i    integer;
  begin
      flag := array_of_booleans(false, true);
      flag.extend(n - 2, 2);
      ptr  := 1;
      << outer_loop >>
      while ptr * ptr <= n loop
          while not flag(ptr) loop
              ptr := ptr + 1;
          end loop;
          i := ptr * ptr;
          while i <= n loop
              flag(i) := false;
              i := i + ptr;
          end loop;
          ptr := ptr + 1;
      end loop outer_loop;
      for i in 1 .. n loop
          if flag(i) then
              pipe row (i);
          end if;
      end loop;
      return;
  end find_primes;
end sieve_of_eratosthenes;
/
