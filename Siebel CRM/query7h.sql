--
-- 14 Nov 2022 To get User info.
-- See indexes S_USER_U[12]
-- PAR_ROW_IDs in S_CONTACT and S_USER are unique, See indexes S_CONTACT_U2 and S_USER_U2
--
-- input(public) variables
variable vc_row_id VARCHAR2(15) ;

begin
  :vc_row_id := '1-O1UTZ' ;
end ;
/
show error 

print :vc_row_id

set markup csv on delimiter ',' quote on 
spool User_Timezone.csv

SELECT u.row_id  -- Skip on inspector
, c.alias_name AS Alias
--, NULL AS CallCenterId
--, c.nick_name AS Nickname
, 'TBD' AS CurrencyIsoCode
, 'TBD' AS DefaultGrpNotifFreq  -- DefaultGroupNotificationFrequency
, 'TBD' AS DigestFrequency  -- Chatter Email Highlights Frequency
, c.email_addr AS Email
, 'UTF-8' AS EmailEncodingKey
--, '' AS EmailPrefAutoBcc
--, '' AS EmailPrefAutoBccStayInTouch
--, '' AS EmailPrefStayInTouchReminder
, c.pref_lang_id
, (SELECT posix_locale_cd FROM S_LOCALE WHERE row_id = c.pref_lang_id) AS LanguageLocaleKey
, c.pref_locale_id
, (SELECT posix_locale_cd FROM S_LOCALE WHERE row_id = c.pref_locale_id) AS LocaleSidKey  -- POSIX_LOCALE_CD in S_LOCALE
, c.last_name AS Name  -- Full Name
--, c.fst_name||' '||c.last_name AS "Name"  -- Full Name
, NULL AS ProfileId
, c.timezone_id  -- AS TimeZoneSidKey
, (SELECT name FROM S_TIMEZONE WHERE row_id = c.timezone_id) AS "Timezone"
, u.login AS Username
--, u.login_domain  -- not null for 23 rows
--, u.conflict_id   '0' for all 16,797 rows
FROM S_CONTACT c 
, S_USER u 
, S_PARTY p 
--, S_LOCALE l
--, S_TIMEZONE tz
WHERE c.par_row_id = p.row_id
AND u.par_row_id = p.row_id
--AND c.pref_locale_id = l.row_id
--AND c.timezone_id = tz.row_id
AND u.x_login_active_flg = 'Y'
AND u.row_id = :vc_row_id
/

SELECT tz.row_id 
, tz.utc_offset
--, tz.std_abbrev
, tz.name
FROM S_TIMEZONE tz 
/
/*
SELECT row_id
, posix_locale_cd AS LocaleSidKey 
FROM S_LOCALE 
*/
spool off
