--
-- 32,764 = 8,191 x 4 bytes
-- 24,573 = 8,191 x 3 bytes
--
DECLARE
  vc_own_name VARCHAR2(128) ;
  vc_tab_name VARCHAR2(128) ;
  vc_col_name VARCHAR2(4000) ;
  vc_row_id VARCHAR2(18) ;

  vc_sel_str VARCHAR2(255) ;
  TYPE blobCurTyp IS REF CURSOR ;
  c_blob blobCurTyp ;
  blob_loc BLOB ;

  buf_len CONSTANT INTEGER := 24573 ;
  buf RAW(buf_len) ;
  n_amount INTEGER := buf_len ;
  vc_str VARCHAR2(32764) ;
  n_offset INTEGER := 1 ;
BEGIN
  vc_sel_str := 'SELECT '||vc_col_name||' FROM '||vc_tab_name||' WHERE Rowid = '''||vc_row_id||''' ' ;
  OPEN c_blob FOR vc_sel_str ;
  FETCH c_blob INTO blob_loc ;
  LOOP
    DBMS_LOB.READ( blob_loc, n_amount, n_offset, buf ) ;
    EXIT WHEN n_amount = 0 ;
    n_offset := n_offset + n_amount - 1 ;

    vc_str := utl_raw.cast_to_varchar2(utl_encode.base64_encode(buf)) ;
    DBMS_output.put_line(vc_str) ;
  END LOOP ;
  CLOSE c_blob ;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_output.put_line(SQLErrM) ;
END ;
/
show error
