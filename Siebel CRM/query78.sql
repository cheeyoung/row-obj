--
-- To Get a Column info. of a Base Table (Siebel)
--
-- input(public) variables
variable vc_table_name VARCHAR2(30) ;
variable vc_repository_name VARCHAR2(75) ;

-- private variables
variable vc_table_id VARCHAR2(15) ;
variable vc_repository_id VARCHAR2(15) ;

begin
  :vc_table_name := 'S_ORG_EXT' ;
  :vc_repository_name := 'Siebel Repository' ;
end ;
/
show error

begin 
  -- Repository name is unique, See index S_REPOSITORY_U1
  SELECT row_id INTO :vc_repository_id FROM S_REPOSITORY 
  WHERE name = :vc_repository_name ;

  -- Table name is unique in a repository, See index S_TABLE_U1
  SELECT row_id INTO :vc_table_id FROM S_TABLE 
  WHERE name = :vc_table_name AND repository_id = :vc_repository_id ;
end ;
/
show error

set markup csv on delimiter ',' quote on 
spool query78.csv
show user

print :vc_table_id :vc_table_name
print :vc_repository_id :vc_repository_name

SELECT :vc_table_name AS "Table"
, c.name AS "Column"
, decode(c.data_type, 'C', 'CHAR', 'D', 'DATE', 'N', 'NUMBER', 'V', 'VARCHAR', 'X', 'LONG', c.data_type) AS "Type"
, c.prec_num, c.scale
, c.length AS "Length"
FROM S_COLUMN c 
WHERE c.repository_id = :vc_repository_id
AND c.tbl_id = :vc_table_id
ORDER BY 3
/
spool off
