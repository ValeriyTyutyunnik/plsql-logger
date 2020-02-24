/**
  This is base script for table create. Add tablespace, indexes and partitions as you need.
 */

create table logger_logs (log_id     number generated always as identity (start with 1 maxvalue 9999999999999999999999999999 minvalue 1 nocycle cache 20),
                          lvl        varchar2(1)   not null,
                          time       timestamp     not null,
                          sid        number,
                          sessionid  number,
                          module     varchar2(200),
                          action     varchar2(200),
                          info       varchar2(4000),
                          user_login varchar2(200),
                          backtrace  varchar2(4000),
                          errorstack varchar2(4000)
                         );

comment on table logger_logs             is 'Logging table for logger package';
comment on column logger_logs.log_id     is 'PK. Auto generated id';
comment on column logger_logs.lvl        is 'The log level. Possible values: I, T, W, E, F';
comment on column logger_logs.time       is 'Systimestamp';
comment on column logger_logs.sid        is 'Session sid - SYS_CONTEXT(''USERENV'', ''SID'')';
comment on column logger_logs.sessionid  is 'Audit sid. Great to group sql call - SYS_CONTEXT (''USERENV'', ''SESSIONID'')';
comment on column logger_logs.module     is 'Session module (dbms_application_info) or logger call module: logger.i(''text'', module => ''my_module'')';
comment on column logger_logs.action     is 'Session action (dbms_application_info) or logger call action: logger.i(''text'', action => ''my_action'')';
comment on column logger_logs.info       is 'Log message';
comment on column logger_logs.user_login is 'user()';
comment on column logger_logs.backtrace  is 'dbms_utility.format_error_stack()';
comment on column logger_logs.errorstack is 'dbms_utility.format_error_backtrace()';


create unique index logger_logs$log_id on logger_logs (log_id);
alter table logger_logs add constraint logger_logs$pk primary key (log_id) using index logger_logs$log_id;

create index logger_logs$time$lvl on logger_logs (time, lvl);
create index logger_logs$sid on logger_logs (sid);
