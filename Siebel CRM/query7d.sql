--
-- 03 Nov 2022 To List File(Attachment) info. in a Service Request or an Order
-- Set NLS_LANG=AMERICAN_AMERICA.AL32UTF8 before running SQL*Plus
--
-- input(public) variables
variable vc_str VARCHAR2(75) ;
variable vc_dir_name VARCHAR2(200) ;
variable vc_order_num VARCHAR2(30) ;
variable vc_sr_num VARCHAR2(64) ;

-- private variables
variable vc_order_id VARCHAR2(15) ;
variable vc_sr_id VARCHAR2(15) ;

begin 
  :vc_str := 'Order' ;
  :vc_dir_name := '' ;  -- D:\SBA811
  :vc_order_num := 'S20016_0-140641' ;  -- Production DB
  :vc_order_num := 'S20016_0-140639' ;
  :vc_sr_num := 'Direct-201407140001' ;
end ;
/
show error

begin 
  -- See index S_SRV_REQ_U[12] (SR_NUM, BU_ID, CONFLICT_ID)
  SELECT row_id INTO :vc_order_id FROM S_ORDER
  WHERE order_num = :vc_order_num ;  
  -- See index S_SR_ORDER_U1 (PAR_ROW_ID, FILE_NAME, FILE_EXT, CONFLICT_ID)
  -- All the 365,532 rows has '0' in CONFLICT_ID column 
  -- AND conflict_id = 0

  -- See index S_SRV_REQ_U[12] (SR_NUM, BU_ID, CONFLICT_ID)
  --SELECT row_id INTO :vc_sr_id FROM S_SRV_REQ 
  --WHERE sr_num = :vc_sr_num AND conflict_id = 0 ;
  -- See index S_SR_ATT_U1 (PAR_ROW_ID, FILE_NAME, FILE_EXT, CONFLICT_ID)
end ;
/
show error 

print :vc_order_id :vc_order_num
print :vc_sr_id :vc_sr_num

set markup csv on delimiter ',' quote on
spool query7d.csv

-- See Unique index S_SR_ATT_U1 (PAR_ROW_ID, FILE_NAME, FILE_EXT, CONFLICT_ID)
SELECT :vc_str AS " "  -- OER(1741) for ""
--, o.row_id
, o.order_num
--SELECT sr.row_id AS "SR ID"
--, sr.sr_num AS "SR NUM"
--, att.row_id AS "Att ID"
--, att.par_row_id 
, att.file_name||'.'||att.file_ext AS "Filename"
--, att.conflict_id 
--, att.file_rev_num
, att.file_size AS "Bytes"
, att.file_date
, att.file_src_type
, att.file_src_path
FROM S_ORDER o  -- S__REQ sr 
, S_ORDER_ATT att  -- S_SR_ATT att 
WHERE att.par_row_id = o.row_id
AND o.row_id = :vc_order_id
--WHERE att.par_row_id = sr.row_id
--AND sr.row_id = :vc_sr_id
/
spool off
set markup csv off
