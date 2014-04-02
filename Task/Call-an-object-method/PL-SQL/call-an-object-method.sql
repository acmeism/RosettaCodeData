create or replace TYPE myClass AS OBJECT (
    -- A class needs at least one member even though we don't use it
    dummy NUMBER,
    STATIC FUNCTION static_method RETURN VARCHAR2,
    MEMBER FUNCTION instance_method RETURN VARCHAR2
);
/
CREATE OR REPLACE TYPE BODY myClass AS
    STATIC FUNCTION static_method RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Called myClass.static_method';
    END static_method;

    MEMBER FUNCTION instance_method RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Called myClass.instance_method';
    END instance_method;
END;
/

DECLARE
    myInstance myClass;
BEGIN
    myInstance := myClass(null);
    DBMS_OUTPUT.put_line( myClass.static_method() );
    DBMS_OUTPUT.put_line( myInstance.instance_method() );
END;/
