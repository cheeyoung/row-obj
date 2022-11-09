--
-- 09 Nov 2022
--
-- input(public) variables
variable vc_bc_name VARCHAR2(75) ;
variable vc_repository_name VARCHAR2(75) ;

-- private variables
variable vc_bc_id VARCHAR2(15) ;
variable vc_bc_tab_name VARCHAR2(75) ;
variable vc_repository_id VARCHAR2(15) ;

begin
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
  SELECT row_id, table_name INTO :vc_bc_id, :vc_bc_tab_name FROM S_BUSCOMP 
  WHERE name = :vc_bc_name AND repository_id = :vc_repository_id ;

  -- Link name is unique in a repository, See index S_LINK_U1
end ;
/
show error 

print :vc_bc_id :vc_bc_name
print :vc_repository_id :vc_repository_name 

SELECT NULL AS " "
--, k.name 
, k.parent_bc_name
, k.dst_fld_name
, k.inter_tbl_name
, k.child_bc_name
, k.src_fld_name
FROM S_LINK k
WHERE k.repository_id = :vc_repository_id
AND k.parent_bc_name = :vc_bc_name
/
