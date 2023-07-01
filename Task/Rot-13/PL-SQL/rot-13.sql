-- Works for VARCHAR2 (up to 32k chars)
CREATE OR REPLACE FUNCTION fn_rot13_native(p_text VARCHAR2) RETURN VARCHAR2 IS
  c_source CONSTANT VARCHAR2(52) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  c_target CONSTANT VARCHAR2(52) := 'NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm';
BEGIN
  RETURN TRANSLATE(p_text, c_source, c_target);
END;
/

-- For CLOBs (translate only works with VARCHAR2, so do it in chunks)
CREATE OR REPLACE FUNCTION fn_rot13_clob(p_text CLOB) RETURN CLOB IS
  c_source CONSTANT VARCHAR2(52) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  c_target CONSTANT VARCHAR2(52) := 'NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm';
  c_chunk_size CONSTANT PLS_INTEGER := 4000;
  v_result CLOB := NULL;
BEGIN
  FOR i IN 0..TRUNC(LENGTH(p_text) / c_chunk_size) LOOP
    v_result := v_result ||
      TRANSLATE(dbms_lob.substr(p_text, c_chunk_size, i * c_chunk_size + 1), c_source, c_target);
  END LOOP;
  RETURN v_result;
END;
/

-- The full algorithm (Slower. And MUCH slower if using CLOB!)
CREATE OR REPLACE FUNCTION fn_rot13_algorithm(p_text VARCHAR2) RETURN CLOB IS
  c_upper_a CONSTANT PLS_INTEGER := ASCII('A');
  c_lower_a CONSTANT PLS_INTEGER := ASCII('a');
  v_rot VARCHAR2(32000);
  v_char VARCHAR2(1);
BEGIN
  FOR i IN 1..LENGTH(p_text) LOOP
    v_char := SUBSTR(p_text, i, 1);
    IF v_char BETWEEN 'A' AND 'Z' THEN
      v_rot := v_rot || CHR(MOD(ASCII(v_char) - c_upper_a + 13, 26) + c_upper_a);
    ELSIF v_char BETWEEN 'a' AND 'z' THEN
      v_rot := v_rot || CHR(MOD(ASCII(v_char) - c_lower_a + 13, 26) + c_lower_a);
    ELSE
      v_rot := v_rot || v_char;
    END IF;
  END LOOP;
  RETURN v_rot;
END;
/
