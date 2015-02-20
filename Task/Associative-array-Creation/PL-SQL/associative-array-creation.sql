DECLARE
    type ThisIsNotAnAssocArrayType is record (
        myShape VARCHAR2(20),
        mySize number,
        isActive BOOLEAN
    );
    assocArray ThisIsNotAnAssocArrayType ;
BEGIN
    assocArray.myShape := 'circle';

    dbms_output.put_line ('assocArray.myShape: ' || assocArray.myShape);
    dbms_output.put_line ('assocArray.mySize: ' || assocArray.mySize);
END;
/
