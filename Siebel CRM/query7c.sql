--
-- 01 Nov 2022 Created to get Web Template info.
--
-- input
--variable vc_applet_name VARCHAR2(75) ;
variable vc_template_name VARCHAR2(75) ;
variable vc_repository_name VARCHAR2(75) ;

--
--variable vc_applet_id VARCHAR2(15) ;
variable vc_template_id VARCHAR2(15) ;
variable vc_repository_id VARCHAR2(15) ;

-- input
begin
  :vc_template_name := 'Applet Form Grid Layout' ;
  :vc_repository_name := 'Siebel Repository' ;
end ;
/
show error

begin
  -- Repository name is unique, See index S_REPOSITORY_U1
  SELECT row_id INTO :vc_repository_id FROM S_REPOSITORY 
  WHERE name = :vc_repository_name ;
  -- Web Template name is unique in a repository, See index S_WEB_TMPL_U1
  SELECT row_id INTO :vc_template_id FROM S_WEB_TMPL 
  WHERE name = :vc_template_name AND repository_id = :vc_repository_id ;
end ;
/
show error

print :vc_template_id :vc_template_name
print :vc_repository_id :vc_repository_name

SELECT f.row_id
, f.web_tmpl_id
, f.file_name
, f.markup_lang_cd
FROM S_WEB_TMPL_FILE f
WHERE f.web_tmpl_id = :vc_template_id
/
