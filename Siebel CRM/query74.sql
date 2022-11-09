--
-- 17 Oct 2022 Created
--
-- input(public) variables
variable vc_bc_name VARCHAR2(75) ;
variable vc_repository_name VARCHAR2(75) ;

-- private variables
variable vc_bc_id VARCHAR2(15) ;
variable vc_bc_tab_name VARCHAR2(75) ;
variable vc_join_name VARCHAR2(75) ;
variable vc_table_name VARCHAR2(30) ;
variable vc_repository_id VARCHAR2(15) ;

begin
  :vc_bc_name := 'Account' ;
--  :vc_join_name := 'S_ORG_EXT_X' ;  -- S_ORG_EXT_X is also a name of Siebel Joins
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

  -- Field name is unique in a BC id, See index S_FIELD_U1
  -- Join(Siebel) name is unique in a business component, See index S_JOIN_U1
end ;
/
show error

print :vc_bc_id :vc_bc_name :vc_bc_tab_name
print :vc_repository_id :vc_repository_name

set markup csv on delimiter ',' quote off
spool query74.csv
show user

SELECT NULL AS " "
, bc.name
, bc.table_name
--, bc.comments
, f.name
, f.dest_fld_name 
, f.col_name 
, f.type
, j.outer_join
, j.name
, j.dest_tbl_name
--, j.comments
, js.name
, js.dest_col_name
, js.src_fld_name
FROM S_FIELD f
, S_BUSCOMP bc  -- Business Components
, S_JOIN j
, S_JOIN_SPEC js
WHERE f.buscomp_id = bc.row_id
AND f.join_name = j.name 
AND j.buscomp_id = bc.row_id
AND bc.row_id = :vc_bc_id 
AND js.join_id = j.row_id
AND js.repository_id = :vc_repository_id
ORDER BY j.name, js.name
/
spool off
set markup csv off
