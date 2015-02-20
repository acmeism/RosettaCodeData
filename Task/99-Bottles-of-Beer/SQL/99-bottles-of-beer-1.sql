select
        ( 100 - level ) || ' bottle' || case 100 - level when 1 then '' else 's' end || ' of beer on the wall'
        || chr(10)
        || ( 100 - level ) || ' bottle' || case 100 - level when 1 then '' else 's' end || ' of beer'
        || chr(10)
        || 'Take one down, pass it around'
        || chr(10)
        || ( 99 - level ) || ' bottle' || case 99 - level when 1 then '' else 's' end || ' of beer on the wall'
        from dual connect by level <= 99;
