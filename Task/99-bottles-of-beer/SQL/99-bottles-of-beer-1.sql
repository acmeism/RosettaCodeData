select
        ( 100 - level ) || ' bottle' || case when level != 99 then 's' end || ' of beer on the wall'
        || chr(10)
        || ( 100 - level ) || ' bottle' || case when level != 99 then 's' end || ' of beer'
        || chr(10)
        || 'Take one down, pass it around'
        || chr(10)
        || ( 99 - level ) || ' bottle' || case when level != 98 then 's' end || ' of beer on the wall'
        from dual connect by level <= 99;
