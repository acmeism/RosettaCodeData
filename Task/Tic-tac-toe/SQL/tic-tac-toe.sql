--Setup
drop table if exists board;
create table board (p char, r integer, c integer);
insert into board values('.', 0, 0),('.', 0, 1),('.', 0, 2),('.', 1, 0),('.', 1, 1),('.', 1, 2),('.', 2, 0),('.', 2, 1),('.', 2, 2);


-- Use a trigger for move events
drop trigger if exists after_moved;
create trigger after_moved after update on board for each row when new.p <> '.' and new.p <> 'O'
begin

    -- Verify move is valid
    select
        case
            when (select v from msg) like '%Wins!' then raise(ABORT, 'The game is already over.')
            when (select old.p from board where rowid = rid) <> '.' then raise(ABORT, 'That position has already been taken.  Please choose an available position.')
            when new.p <> 'X' then raise(ABORT, 'Please place an ''X''')
        end
    from (
        select rowid rid from board
        where p = new.p
        except
        select p from board where p = old.p
    );


    -- Check for game over
    update msg set v = (
        select
            case
                when max(num) >= 3 then 'X Wins!'
                when (select count(*) from board where p = '.') = 0 then 'Cat Wins!'
                else 'Move made'
            end
        from ( -- Is Game Over
            select count(*) num from board where p = 'X' group by r union -- Horz
            select count(*) num from board where p = 'X' group by c union -- Vert
            select count(*) num from board where p = 'X' and r = c union -- Diag TL->BR
            select count(*) num from board where p = 'X' and (2-r) = c -- Diag TR->BL
        )
    );


    --Have computer player make a random move
    update board set p = 'O'
    where rowid = (select rid from (select max(rnd),rid from (select rowid rid, random() rnd from board where p = '.')))
    and (select v from msg) not like '%Wins!';
    --NOTE: SQLite doesn't allow update order by in triggers, otherwise we could just use this beautiful line:
    -- update board set p = 'O' where p = '.' order by random() limit 1;

    --Check to see if the computer player won
    update msg set v = (
        select
            case
                when max(num) >= 3 then 'O Wins!'
                else v
            end
        from ( -- Is Game Over
            select count(*) num from board where p = 'O' group by r union -- Horz
            select count(*) num from board where p = 'O' group by c union -- Vert
            select count(*) num from board where p = 'O' and r = c union -- Diag TL->BR
            select count(*) num from board where p = 'O' and (2-r) = c -- Diag TR->BL
        )
    );


end;

-- UI to display the logical board as a grid
drop view if exists ui;
create view ui as
select case when p = '.' then col0.rowid else p end c0, c1, c2
from board as col0
join (select case when p = '.' then board.rowid else p end c1, r from board where c = 1) as col1 on col0.r = col1.r
join (select case when p = '.' then board.rowid else p end  c2, r from board where c = 2) as col2 on col0.r = col2.r
where c = 0;

drop table if exists msg;
create table msg (v text);
insert into msg values('');

-- Readme
select * from ui;
.print "Use this to play:"
.print "->update board set p = 'X' where rowid = ?; select * from ui; select * from msg;"'
