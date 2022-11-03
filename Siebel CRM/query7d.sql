--
-- 03 Nov 2022
-- Set NLS_LANG=AMERICAN_AMERICA.AL32UTF8 before running SQL*Plus
--
-- input(public) variables
variable vc_sr_num VARCHAR2(64) ;

-- private variables
variable vc_sr_id VARCHAR2(15) ;

begin 
  :vc_sr_num := 'Direct-201407140001' ;
end ;
/
show error

begin 
  -- See index S_SRV_REQ_U[12] (SR_NUM, BU_ID, CONFLICT_ID)
  SELECT row_id INTO :vc_sr_id FROM S_SRV_REQ 
  WHERE sr_num = :vc_sr_num AND conflict_id = 0;
  -- See index S_SR_ATT_U1 (PAR_ROW_ID, FILE_NAME, FILE_EXT, CONFLICT_ID)
end ;
/
show error 

print :vc_sr_id :vc_sr_num

set markup csv on delimiter ',' quote on
spool query7d.csv

SELECT sr.row_id AS "SR ID"
, sr.sr_num AS "SR NUM"
, att.par_row_id
, att.row_id AS "Att ID"
, att.conflict_id 
, att.file_name||'.'||att.file_ext AS "Filename"
, att.file_rev_num
, att.file_size AS "Bytes"
--, att.file_date
, att.file_src_type
, att.file_src_path
FROM S_SRV_REQ sr 
, S_SR_ATT att 
WHERE att.par_row_id = sr.row_id
AND sr.row_id = :vc_sr_id
/
spool off
set markup csv off
