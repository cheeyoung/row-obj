--
-- 28 Oct 2022 Created to get Field info.
--
-- input
variable vc_bc_name VARCHAR2(75) ;
variable vc_field_name VARCHAR2(75) ;
variable vc_repository_name VARCHAR2(75) ;

--
variable vc_bc_id VARCHAR2(15) ;
variable vc_field_id VARCHAR2(15) ;
variable vc_repository_id VARCHAR2(15) ;

-- input
begin
  :vc_field_name := 'Street Address 2' ;
  :vc_field_name := 'Employee Id' ;
  :vc_bc_name := 'Account' ;
  :vc_repository_name := 'Siebel Repository' ;
end ;
/
show error

begin
  -- Repository name is unique, See index S_REPOSITORY_U1
  SELECT row_id INTO :vc_repository_id FROM S_REPOSITORY 
  WHERE name = :vc_repository_name ;
  -- BC name is unique in a repository, See index S_BUSCOMP_U1
  SELECT row_id INTO :vc_bc_id FROM S_BUSCOMP 
  WHERE name = :vc_bc_name AND repository_id = :vc_repository_id ;
  -- Field name is unique in a BC id, See index S_FIELD_U1
  SELECT row_id INTO :vc_field_id FROM S_FIELD 
  WHERE name = :vc_field_name AND buscomp_id = :vc_bc_id AND repository_id = :vc_repository_id ;
end ;
/
show error

print :vc_field_id :vc_field_name
print :vc_bc_id :vc_bc_name
print :vc_repository_id :vc_repository_name

SELECT f.calculated, f.calcval
, f.name
, f.type
, f.dest_fld_name
FROM S_FIELD f
WHERE f.row_id = :vc_field_id
/

SELECT f.multi_valued
, f.mvlink_name
, f.linkspec
FROM S_FIELD f
WHERE f.row_id = :vc_field_id
/

set long 2000
SELECT f.
, f.col_name
, f.join_name
, f.comments
FROM S_FIELD f
WHERE f.row_id = :vc_field_id
/

begin
  NULL ;
end ;
/
show error
