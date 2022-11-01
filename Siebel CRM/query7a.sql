--
-- 26 Oct 2022 To List the Fields in an List Applet
--
variable vc_applet_name VARCHAR2(75) ;
variable vc_repository_name VARCHAR2(75) ;

variable vc_applet_id VARCHAR2(15) ;
variable vc_repository_id VARCHAR2(15) ;

begin
  :vc_applet_name := 'SIS Account List Applet' ;
  :vc_repository_name := 'Siebel Repository' ;
end ;
/
show error

begin
  -- Repository name is unique, See index S_REPOSITORY_U1
  SELECT row_id INTO :vc_repository_id FROM S_REPOSITORY 
  WHERE name = :vc_repository_name ;
  --
  SELECT row_id INTO :vc_applet_id FROM S_APPLET 
  WHERE name = :vc_applet_name ;
end ;
/
show error

print :vc_applet_id :vc_applet_name
print :vc_repository_id :vc_repository_name

set markup csv on delimiter ',' quote on
spool query7a.csv
show user
print :vc_applet_name

SELECT a.buscomp_name
, a.name
FROM S_APPLET a
WHERE a.row_id = :vc_applet_id
/

SELECT aw.type
, aw.web_template
, aw.expr
, aw.comments
FROM S_APPL_WEB_TMPL aw  -- Applet and Web Template
WHERE aw.applet_id = :vc_applet_id
AND aw.repository_id = :vc_repository_id
/

SELECT lc.row_id
, lc.list_id
, lc.available_flg
, lc.inactive_flg
, lc.visible
, lc.type 
, lc.field_name AS field_name
FROM S_LIST l
, S_LIST_COLUMN lc
WHERE l.applet_id = :vc_applet_id
AND lc.list_id = l.row_id
AND lc.repository_id = :vc_repository_id
ORDER BY 6 ASC
/
set markup csv off
spool off
