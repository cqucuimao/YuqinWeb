﻿insert into privilege(id,name,url,parent_id) values(468,'','/smsRecord_list',260);
insert into privilege(id,name,url,parent_id) values(469,'','/smsRecord_queryList',468);
insert into privilege(id,name,url,parent_id) values(470,'','/smsRecord_freshList',468);
insert into role_privilege(roles_id,privileges_id) values(1,468);

insert into privilege(id,name,url,parent_id) values(471,'','/smsFailRecord_list',260);
insert into role_privilege(roles_id,privileges_id) values(1,471);
insert into privilege(id,name,url,parent_id) values(472,'','/smsFailRecord_freshList',471);
insert into privilege(id,name,url,parent_id) values(473,'','/smsFailRecord_queryList',471);