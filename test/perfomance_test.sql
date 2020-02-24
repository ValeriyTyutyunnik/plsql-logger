declare
  l_time    pls_integer;
  l_cpu     pls_integer;

  function f (b boolean) return varchar2
  is
  begin
    if b then
      return 'true';
    end if;
    return 'false';
  end f;
begin
-- For perfomance test one log level should be disabled and one is enabled

  execute immediate 'truncate table logger_logs';
  l_time := dbms_utility.get_time;
  l_cpu  := dbms_utility.get_cpu_time;

  for i in 1 .. 1000000 loop
    logger.w('hello, %s!', 'world');
  end loop;
  dbms_output.put_line('log level warn enabled is ' || f(logger.warning_enabled) ||
                       '. time=' || to_char(dbms_utility.get_time - l_time) || ' hsecs' ||
                       '. cpu time=' || (dbms_utility.get_cpu_time - l_cpu) || ' hsecs');

  execute immediate 'truncate table logger_logs';
  l_time := dbms_utility.get_time;
  l_cpu  := dbms_utility.get_cpu_time;

  for i in 1 .. 1000000 loop
    logger.e('hello, %s!', 'world');
  end loop;
  dbms_output.put_line('log level error enabled is ' || f(logger.error_enabled) ||
                       '. time=' || to_char(dbms_utility.get_time - l_time) || ' hsecs' ||
                       '. cpu time=' || (dbms_utility.get_cpu_time - l_cpu) || ' hsecs');


  execute immediate 'truncate table logger_logs';
end;
/
