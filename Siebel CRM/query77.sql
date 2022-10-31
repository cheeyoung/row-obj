--
-- 31 Oct 2022 To List Controls 
--

-- input
variable vc_applet_name VARCHAR2(75) ;
variable vc_repository_name VARCHAR2(75) ;
variable vc_control_type VARCHAR2(30) ;

--
variable vc_applet_id VARCHAR2(15) ;
variable vc_repository_id VARCHAR2(15) ;

begin
  :vc_applet_name := 'SIS Account Entry Applet' ;
  :vc_repository_name := 'Siebel Repository' ;
end ;
/
show error

begin
  -- Repository name is unique, See index S_REPOSITORY_U1
  SELECT row_id INTO :vc_repository_id FROM S_REPOSITORY 
  WHERE name = :vc_repository_name ;
  -- Applet name is unique in a repository, See index S_APPLET_U1
  SELECT row_id INTO :vc_applet_id FROM S_APPLET 
  WHERE name = :vc_applet_name AND repository_id = :vc_repository_id ;
end ;
/
show error
print :vc_repository_id :vc_repository_name
print :vc_applet_id :vc_applet_name

set markup csv on delimiter ',' quote on
spool query77.csv
show user
print :vc_applet_name

SELECT c.type
--, c.name
--, c.type
, c.multi_line
--, c.caption
, c.field_name
, c.field_type_cd
--, c.field_retrieval_cd
, c.comments
FROM S_CONTROL c
WHERE c.applet_id = :vc_applet_id
AND c.repository_id = :vc_repository_id
ORDER BY 3
/
set markup csv off
spool off
