--
-- 31 Oct 2022 To List Symbol Strings and BC Fields 
--

-- input
variable vc_str VARCHAR2(75) ;
variable vc_applet_name VARCHAR2(75) ;
variable vc_bc_name VARCHAR2(75) ;
variable vc_repository_name VARCHAR2(75) ;

variable vc_symstr_name VARCHAR2(75) ;
variable vc_control_type VARCHAR2(30) ;
variable vc_project_name VARCHAR2(75) ;

--
variable vc_bc_tab_name VARCHAR2(75) ;
variable vc_applet_id VARCHAR2(15) ;
variable vc_bc_id VARCHAR2(15) ;
variable vc_repository_id VARCHAR2(15) ;

begin
  :vc_str := 'RMA/RMA/심사/첨부 파일' ;
  :vc_applet_name := 'Service Request Attachment List Applet' ;
  :vc_bc_name := 'Service Request Attachment' ;

  :vc_repository_name := 'Siebel Repository' ;
  :vc_symstr_name := 'X_ACCNT_CHANNEL' ;
  :vc_project_name := 'STW Symbolic Strings' ;
  :vc_repository_name := 'Siebel Repository' ;
end ;
/
show error

begin
  -- Repository name is unique, See index S_REPOSITORY_U1
  SELECT row_id INTO :vc_repository_id FROM S_REPOSITORY 
  WHERE name = :vc_repository_name ;
  -- BC name is unique in a repository, See index S_BUSCOMP_U1
  SELECT row_id, table_name INTO :vc_bc_id, :vc_bc_tab_name FROM S_BUSCOMP 
  WHERE name = :vc_bc_name AND repository_id = :vc_repository_id ;
  -- Applet name is unique in a repository, See index S_APPLET_U1
  SELECT row_id INTO :vc_applet_id FROM S_APPLET 
  WHERE name = :vc_applet_name AND repository_id = :vc_repository_id ;
  -- Control name is unique in an applet, See index S_CONTROL_U1
end ;
/
show error
print :vc_applet_id :vc_applet_name
print :vc_bc_id :vc_bc_name :vc_bc_tab_name
print :vc_repository_id :vc_repository_name

set markup csv on delimiter ',' quote on
spool query77.csv
show user
print :vc_applet_name

SELECT c.row_id
, c.type
--, c.name
--, c.type
, c.multi_line
--, c.caption
, c.field_name
, c.field_type_cd
--, c.field_retrieval_cd
, c.caption
, c.caption_ref
--, c.comments
FROM S_CONTROL c
WHERE c.applet_id = :vc_applet_id
AND c.repository_id = :vc_repository_id
ORDER BY 3
/

SELECT s.name
, si.string_value
FROM S_SYM_STR_INTL si  
, S_SYM_STR s 
-- The names of Symbol Strings are unique in a Repository, See index S_SYM_STR_U1 
-- See index S_SYM_STR_INTL_U1 (sym_str_id, name)
WHERE s.name = :vc_symstr_name
AND si.lang_cd = 'KOR'
AND si.sym_str_id = s.row_id
AND s.repository_id = :vc_repository_id
/
spool off

--accept ch_tab_name CHAR prompt 'Enter Tab name: '
undefine ch_tab_name
spool caption_to_field_name.csv
SELECT NULL AS "Sf Object"
, NULL AS "Field API"
--ch_tab_name
, :vc_str
, si.string_value
--, c.name
--, c.type
, c.field_name
, c.field_type_cd
--, c.type
--, c.multi_line
, nvl2(f.col_name, :vc_bc_tab_name, NULL) AS "DB Table"
, f.col_name "Column"
, nvl2(f.col_name, f.join_name, NULL) AS "Join Name"
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
AND si.lang_cd = 'ENU' --'KOR'
AND si.sym_str_id = s.row_id
AND c.repository_id = :vc_repository_id
AND c.field_type_cd = 'BC Field'
AND c.field_name = f.name
AND f.buscomp_id = :vc_bc_id
ORDER BY 4
/
set markup csv off
spool off
