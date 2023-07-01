    -- Create Table
    -- Distinct combination
    --- R :Red, B :Blue, G: Green, V: Violet, O: Orange, Y: Yellow
    DROP TYPE IF EXISTS color cascade;CREATE TYPE color AS ENUM ('R', 'B', 'G', 'V', 'O', 'Y');

    DROP TABLE IF EXISTS guesses cascade ; CREATE TABLE guesses (
        first color,
        second color,
        third color ,
        fourth color
    );
    CREATE TABLE mastermind () inherits (guesses);

    INSERT INTO mastermind values ('G', 'B', 'R', 'V');


    INSERT INTO guesses values ('Y', 'Y', 'B', 'B');
    INSERT INTO guesses values ('V', 'R', 'R', 'Y');
    INSERT INTO guesses values ('G', 'V', 'G', 'Y');
    INSERT INTO guesses values ('R', 'R', 'V', 'Y');
    INSERT INTO guesses values ('B', 'R', 'G', 'V');
    INSERT INTO guesses values ('G', 'B', 'R', 'V');


    --- Matches Black
    CREATE OR REPLACE FUNCTION check_black(guesses,  mastermind) RETURNS integer AS $$
        SELECT (
            ($1.first  = $2.first)::int +
            ($1.second  = $2.second)::int +
            ($1.third = $2.third)::int +
            ($1.fourth = $2.fourth)::int
        );
    $$ LANGUAGE SQL;

    --- Matches White
    CREATE OR REPLACE FUNCTION check_white(guesses,  mastermind) RETURNS integer AS $$
        SELECT (
            case when ($1.first = $2.first) then 0 else 0 end +
            case when ($1.second = $2.second) then 0 else 0 end +
            case when ($1.third = $2.third)  then 0 else 0 end +
            case when ($1.fourth = $2.fourth) then 0 else 0 end +
            case when ($1.first != $2.first) then (
                    $1.first = $2.second or
                    $1.first = $2.third or
                    $1.first = $2.fourth
                    )::int else 0 end +
            case when ($1.second != $2.second) then (
                    $1.second = $2.first or
                    $1.second = $2.third or
                    $1.second = $2.fourth
                    )::int else 0 end +
            case when ($1.third != $2.third) then (
                    $1.third = $2.first or
                    $1.third = $2.second or
                    $1.third = $2.fourth
                    )::int else 0 end +
            case when ($1.fourth != $2.fourth) then (
                    $1.fourth = $2.first or
                    $1.fourth = $2.second or
                    $1.fourth = $2.third
                    )::int else 0 end
        ) from guesses
    $$ LANGUAGE SQL;



    SELECT guesses,
           check_black(guesses.*, mastermind.*),
           check_white(guesses.*, mastermind.*)
        FROM   guesses, mastermind
