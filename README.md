# plsql-logger

### Logger
Simple and effective logger framework for Oracle Database

### Requirements
Oracle RDBMS 12c and above

### Setup
1. Download
2. Create log table @/Source/logger_log_table.sql
3. Create logger_conf package @Source/logger_conf_package.sql
4. Create logger package @Source/logger_package.sql
5. Use it
```sql
begin
  logger.i('This is info message');
end;
```

### Options
```sql
begin
  logger.i("information");
  logger.t("trace");
  logger.w("warning");
  logger.e("error");
  logger.f("fatal");
end;
/
select * from logger_logs;
-- This will display all recorded logs
```

String format up to 10 arguments are supported. Avoid runtime concatenation for disabled log levels!
```sql
  logger.i("hello, %s!", "world");
```

To disable some or all log levels - set false in logger_conf package and recompile it.
```sql
  info                constant boolean := false;
  trace               constant boolean := false;
  warning             constant boolean := false;
  error               constant boolean := false;
  fatal               constant boolean := false;
```
Do not use logger_conf package in your code. This will create a HARD link and whenewer you will recompile logger_conf you'll have to recompile linked objects.

If you need to check if log_enable then do like that:
```sql
begin
  if logger.info_enabled then
    logger.i('slow_func result is: %s', slow_func());
  end if;
end;
```
logger_conf package should have only one link with logger package. Then it will be save to recompile logger_conf even in productive database with lot of sessions.
But on productive it's better to create this packages only once and newer recompile it.

By default messages is saves in logger_logs table. But you can enable dbms_output by set logger_conf.print_dbms to true and recompile logger_conf package.
Warning. This setting will affect all sessions.
logger.f('Fatal error') will print something like that if Fatal level is enable:
```
output:
Level: FATAL
Time: 18:54:22.684
Module: Testing logger
Action: my_proc
Description: Fatal error
Error stack: ORA-20099: WTF
Backtrace: ORA-06512: on "MY_SCHEMA.MY_PROC", line 6
```

It's also possible to make a little less output and change date mask by logger_conf session settings
```sql
begin
  logger_conf.timestamp_mask := 'dd-mm-yyyy hh24:mi:ss.ff3';
  logger_conf.print_level := false;
  logger_conf.print_module_action := false;
  logger_conf.print_backtrace := false;
  logger_conf.print_error_stack := false;
  my_proc;
end;

output:
Time: 24-02-2020 19:01:24.191
Description: fatal
```

Some information for the logger_logs columns:

| Columns       | info                                                                                                   |
| ------------- |:------------------------------------------------------------------------------------------------------:|
| log_id        | Auto generated id                                                                                      |
| lvl           | The log level. Possible values: 'I', 'T', 'W', 'E', 'F'                                                |
| time          | Systimestamp                                                                                           |
| sid           | Session sid - SYS_CONTEXT ('USERENV', 'SID')                                                           |
| sessionid     | Audit sid. Great to group sql call - SYS_CONTEXT ('USERENV', 'SESSIONID')                              |
| module        | Session module (dbms_application_info) or logger call module: logger.i('text', module => 'my_module')  |
| action        | Session action (dbms_application_info) or logger call action: logger.i('text', action => 'my_action')  |
| info          | Log message                                                                                            |
| user_login    | user()                                                                                                 |
| errorstack    | dbms_utility.format_error_stack()                                                                      |
| backtrace     | dbms_utility.format_error_backtrace()                                                                  |


### Perfomance
You may not to worry about negative perfomance implications for productive code if you leave logger calls for disabled levels.
When log level is disabled then nothing happens at all.

This is the result for 1000000 logger calls. See @test/perfomance_test.sql
```
log level WARN enabled is false. Time=22 hsecs. CPU Time=22 hsecs
log level ERROR enabled is true. Time=15131 hsecs. CPU Time=14331 hsecs
```
