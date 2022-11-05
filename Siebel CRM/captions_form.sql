--
-- 31 Oct 2022 Cheeyoung O
-- Created to List BC Fields and Table columns
-- with Symbol Strings on a Form Applet (Siebel 8.1.1, Oracle 11.2.0.3)
-- This SQL scripts only works for Form Applet
-- as different SQL statements is needed for List Applet
-- Set NLS_LANG=AMERICAN_AMERICA.AL32UTF8 before running SQL*Plus
-- Use SQL*Plus 12.2 or above to use "set markup csv"
-- if possible, See interoperability Matrix or any known issues between SQL*Plus and 11.2.0.3
--

-- input(public) variables
variable vc_str VARCHAR2(75) ;
variable vc_applet_name VARCHAR2(75) ;
--variable vc_bc_name VARCHAR2(75) ;
variable vc_repository_name VARCHAR2(75) ;

-- private variables.
-- Do not update these variables. Use input variables above
variable vc_applet_id VARCHAR2(15) ;
variable vc_bc_id VARCHAR2(15) ;
variable vc_bc_name VARCHAR2(75) ;
variable vc_bc_tab_name VARCHAR2(75) ;
variable vc_repository_id VARCHAR2(15) ;

-- update input variables here
begin
  :vc_str := 'SWAP주문/출고/invoice' ;
  :vc_applet_name := 'STW SWAP Order Invoice Form Applet' ;
--  :vc_bc_name := 'Order Entry - Orders' ;
--  :vc_str := '고객정보/추가정보' ;  -- Any string to identify a Form applet in a csv
--  :vc_applet_name := 'Account Profile Applet' ;
--  :vc_bc_name := 'Account' ;

  :vc_repository_name := 'Siebel Repository' ;
end ;
/
show error

-- constants, the names of the Foam Applets
begin 
  null ;
end ;
/
show error

-- initialize private variables, 
-- when an error such as ORA-1403, See ORA-6502 for the Line number
begin
  -- Repository name is unique, See index S_REPOSITORY_U1
  SELECT row_id INTO :vc_repository_id FROM S_REPOSITORY 
  WHERE name = :vc_repository_name ;

  -- Applet name is unique in a repository, See index S_APPLET_U1
  SELECT row_id, buscomp_name INTO :vc_applet_id, :vc_bc_name FROM S_APPLET 
  WHERE name = :vc_applet_name AND repository_id = :vc_repository_id ;

  -- BC name is unique in a repository, See index S_BUSCOMP_U1
  SELECT row_id, table_name INTO :vc_bc_id, :vc_bc_tab_name FROM S_BUSCOMP 
  WHERE name = :vc_bc_name AND repository_id = :vc_repository_id ;

  -- Control name is unique in an applet, See index S_CONTROL_U1
end ;
/
show error

-- for debugging
print :vc_applet_id :vc_applet_name
print :vc_bc_id :vc_bc_name :vc_bc_tab_name
print :vc_repository_id :vc_repository_name

-- execute the query with the private variables
set markup csv on delimiter ',' quote on
spool captions_form.csv
show user
print :vc_applet_name :vc_bc_name :vc_bc_tab_name

SELECT NULL AS "Salesforce Object"
, NULL AS "Field API Name"
--, :vc_str 
, si.string_value AS "Caption"
--, c.name
--, c.type
, :vc_bc_name AS "BC Name"  -- See f.buscomp_id = :vc_bc_id
, c.field_name AS "Field Name"
--, c.field_type_cd
--, c.type
--, c.multi_line
, nvl2(f.col_name, :vc_bc_tab_name, NULL) AS "BC Table"
, f.col_name "DB Column"
, nvl2(f.col_name, f.join_name, NULL) AS "Join name"
--, c.inactive_flg
--, c.caption
--, c.field_retrieval_cd
--, c.caption
--, c.caption_ref
--, s.name
--, c.comments
FROM S_CONTROL c
, S_SYM_STR_INTL si 
, S_SYM_STR s 
, S_FIELD f 
WHERE c.applet_id = :vc_applet_id
AND s.name = c.caption_ref
AND s.repository_id = :vc_repository_id
AND si.lang_cd = 'KOR'
AND si.sym_str_id = s.row_id
AND c.repository_id = :vc_repository_id
AND c.field_type_cd = 'BC Field'
AND c.field_name = f.name
AND f.buscomp_id = :vc_bc_id
ORDER BY 4, 5
/
set markup csv off
spool off
