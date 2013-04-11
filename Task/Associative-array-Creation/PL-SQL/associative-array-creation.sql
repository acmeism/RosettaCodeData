DECLARE
    type assocArrayType is record (
        myShape VARCHAR2(20),
        mySize number,
        isActive BOOLEAN
    );
    assocArray assocArrayType;
BEGIN
    assocArray.myShape := 'circle';

    dbms_output.put_line ('assocArray.myShape: ' || assocArray.myShape);
    dbms_output.put_line ('assocArray.mySize: ' || assocArray.mySize);
END;
/
