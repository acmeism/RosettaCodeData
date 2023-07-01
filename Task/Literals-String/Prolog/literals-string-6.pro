test_qq_odbc :-
        myodbc_connect_db(Conn),
        odbc_query(Conn, {|odbc||
select
 P.image,D.description,D.meta_keywords,C.image,G.description
from
 product P, product_description D, category C, category_description G, product_to_category J
where
 P.product_id=D.product_id and
 P.product_id=J.product_id and C.category_id=J.category_id and
 C.category_id=G.category_id
        |}, Row),
        writeln(Row).
