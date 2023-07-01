select 'the quick brown fox jumps over the lazy dog' from sysibm.sysdummy1;
select substr('the quick brown fox jumps over the lazy dog', 5, 15) from sysibm.sysdummy1;
select substr('the quick brown fox jumps over the lazy dog', 32) from sysibm.sysdummy1;
select substr('the quick brown fox jumps over the lazy dog', 1, length ('the quick brown fox jumps over the lazy dog') - 1) from sysibm.sysdummy1;

select locate('j', 'the quick brown fox jumps over the lazy dog') from sysibm.sysdummy1;
select locate_in_string('the quick brown fox jumps over the lazy dog', 'j') from sysibm.sysdummy1;
select posstr('the quick brown fox jumps over the lazy dog', 'j') from sysibm.sysdummy1;
select position('j', 'the quick brown fox jumps over the lazy dog',  OCTETS) from sysibm.sysdummy1;

select substr('the quick brown fox jumps over the lazy dog', locate('j', 'the quick brown fox jumps over the lazy dog')) from sysibm.sysdummy1;

select locate('fox', 'the quick brown fox jumps over the lazy dog') from sysibm.sysdummy1;
select locate_in_string('the quick brown fox jumps over the lazy dog', 'fox') from sysibm.sysdummy1;
select posstr('the quick brown fox jumps over the lazy dog', 'fox') from sysibm.sysdummy1;
select position('fox', 'the quick brown fox jumps over the lazy dog',  OCTETS) from sysibm.sysdummy1;

select substr('the quick brown fox jumps over the lazy dog', locate('fox', 'the quick brown fox jumps over the lazy dog')) from sysibm.sysdummy1;
