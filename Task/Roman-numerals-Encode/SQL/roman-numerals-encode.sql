--
-- This only works under Oracle and has the limitation of 1 to 3999


SQL> select to_char(1666, 'RN') urcoman, to_char(1666, 'rn') lcroman from dual;

URCOMAN         LCROMAN
--------------- ---------------
        MDCLXVI         mdclxvi
