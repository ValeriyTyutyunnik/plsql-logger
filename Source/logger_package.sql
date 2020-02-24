create or replace package logger as
  /**
    MIT License

    Copyright (c) 2020 Valeriy Tyutyunnik

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
  */

  function info_enabled
  return boolean;

  function trace_enabled
  return boolean;

  function warning_enabled
  return boolean;

  function error_enabled
  return boolean;

  function fatal_enabled
  return boolean;

  procedure i (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null);

  procedure t (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null);

  procedure w (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null);

  procedure e (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null);

  procedure f (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null);

end logger;
/

show errors

create or replace package body logger as
  /**
    MIT License

    Copyright (c) 2020 Valeriy Tyutyunnik

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
  */

  function info_enabled
  return boolean
  is
  begin
    return logger_conf.info;
  end info_enabled;


  function trace_enabled
  return boolean
  is
  begin
    return logger_conf.trace;
  end trace_enabled;

  function warning_enabled
  return boolean
  is
  begin
    return logger_conf.warning;
  end warning_enabled;

  function error_enabled
  return boolean
  is
  begin
    return logger_conf.error;
  end error_enabled;

  function fatal_enabled
  return boolean
  is
  begin
    return logger_conf.fatal;
  end fatal_enabled;

  function format (s      varchar2,
                   p1     varchar2,
                   p2     varchar2,
                   p3     varchar2,
                   p4     varchar2,
                   p5     varchar2,
                   p6     varchar2,
                   p7     varchar2,
                   p8     varchar2,
                   p9     varchar2,
                   p10    varchar2)
  return varchar2
  is
    pattern constant varchar2(2) := '%s';
    str              varchar2(32767) := s;
    cnt              integer;
  begin
    cnt := regexp_count(s, pattern);

    if cnt >= 1 then
      str := regexp_replace(str, pattern, p1, 1, 1);
      if cnt >= 2 then
        str := regexp_replace(str, pattern, p2, 1, 1);
        if cnt >= 3 then
          str := regexp_replace(str, pattern, p3, 1, 1);
          if cnt >= 4 then
            str := regexp_replace(str, pattern, p4, 1, 1);
            if cnt >= 5 then
              str := regexp_replace(str, pattern, p5, 1, 1);
              if cnt >= 6 then
                str := regexp_replace(str, pattern, p6, 1, 1);
                if cnt >= 7 then
                  str := regexp_replace(str, pattern, p7, 1, 1);
                  if cnt >= 8 then
                    str := regexp_replace(str, pattern, p8, 1, 1);
                    if cnt >= 9 then
                      str := regexp_replace(str, pattern, p9, 1, 1);
                      if cnt >= 10 then
                        str := regexp_replace(str, pattern, p10, 1, 1);
                      end if;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;

    return str;
  end format;

  $if logger_conf.print_dbms $then
    procedure print_message (p_level  varchar2,
                             p_str    varchar2,
                             p_module varchar2,
                             p_action varchar2)
    is
      l_module varchar2(200);
      l_action varchar2(200);
    begin
      if logger_conf.print_level then
        dbms_output.put_line('Level: '||p_level);
      end if;
      if logger_conf.print_time then
        dbms_output.put_line('Time: '||to_char(systimestamp, logger_conf.timestamp_mask));
      end if;
      if logger_conf.print_module_action then
        if p_module is null and p_action is null then
         dbms_application_info.read_module(l_module, l_action);
         l_module := l_module;
         l_action := l_action;
        else
          if p_module is not null then
            l_module := substr(p_module, 1, 200);
          end if;
          if p_action is not null then
           l_action := substr(p_action, 1, 200);
          end if;
        end if;
        dbms_output.put_line('Module: '||l_module);
        dbms_output.put_line('Action: '||l_action);
      end if;

      dbms_output.put_line('Description: '||p_str);

      if logger_conf.print_error_stack then
        dbms_output.put_line('Error stack: '||rtrim(rtrim(dbms_utility.format_error_stack, chr(10)), chr(13)));
      end if;

      if logger_conf.print_backtrace then
        dbms_output.put_line('Backtrace: '||rtrim(rtrim(dbms_utility.format_error_backtrace, chr(10)), chr(13)));
      end if;

      dbms_output.put_line('');

    end print_message;
  $else
    procedure log_message (p_level       varchar2,
                           p_str         varchar2,
                           p_module      varchar2,
                           p_action      varchar2,
                           p_backtrace   varchar2,
                           p_error_stack varchar2)
    is
      pragma autonomius_transaction;
      l_module varchar2(200);
      l_action varchar2(200);
      l_info   varchar2(4000);
    begin
      if p_module is null and p_action is null then
        dbms_application_info.read_module(l_module, l_action);
      else
        l_module := substr(p_module, 1, 200);
        l_action := substr(p_action, 1, 200);
      end if;

      l_info := substr(p_str, 1, 4000);

      insert into logger_logs (lvl,
                               time,
                               sid,
                               sessionid,
                               module,
                               action,
                               info,
                               user_login,
                               backtrace,
                               errorstack
                               )
      values (p_level,
              systimestamp,
              sys_context('USERENV', 'SID'),
              sys_context('USERENV', 'SESSIONID'),
              l_module,
              l_action,
              l_info,
              user,
              p_backtrace,
              p_error_stack
              );
      commit;
    exception
      when others then
        l_info := sqlerrm(sqlcode);
        insert into logger_logs (lvl, time, info, module, action)
          values ('F', systimestamp, l_info, l_action, l_module);
        commit;
    end log_message;
  $end

  procedure i (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null)
  is
  begin
    $if logger_conf.info $then
      if s is not null then
        $if logger_conf.print_dbms $then
          print_message(p_level    => 'INFO',
                        p_str      => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                        p_module   => module,
                        p_action   => action);
        $else
          log_message(p_level       => 'I',
                      p_str         => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                      p_module      => module,
                      p_action      => action,
                      p_backtrace   => dbms_utility.format_error_backtrace,
                      p_error_stack => dbms_utility.format_error_stack);
        $end
      end if;
      exception
        when others then
          null;
    $else
      null;
    $end
  end i;

  procedure t (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null)
  is
  begin
    $if logger_conf.trace $then
      if s is not null then
        $if logger_conf.print_dbms $then
          print_message(p_level    => 'TRACE',
                        p_str      => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                        p_module   => module,
                        p_action   => action);
        $else
          log_message(p_level       => 'T',
                      p_str         => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                      p_module      => module,
                      p_action      => action,
                      p_backtrace   => dbms_utility.format_error_backtrace,
                      p_error_stack => dbms_utility.format_error_stack);
        $end
      end if;
      exception
        when others then
          null;
    $else
      null;
    $end
  end t;

  procedure w (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null)
  is
  begin
    $if logger_conf.warning $then
      if s is not null then
        $if logger_conf.print_dbms $then
          print_message(p_level    => 'WARN',
                        p_str      => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                        p_module   => module,
                        p_action   => action);
        $else
          log_message(p_level       => 'W',
                      p_str         => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                      p_module      => module,
                      p_action      => action,
                      p_backtrace   => dbms_utility.format_error_backtrace,
                      p_error_stack => dbms_utility.format_error_stack);
        $end
      end if;
      exception
        when others then
          null;
    $else
      null;
    $end
  end w;

  procedure e (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null)
  is
  begin
    $if logger_conf.error $then
      if s is not null then
        $if logger_conf.print_dbms $then
          print_message(p_level    => 'ERROR',
                        p_str      => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                        p_module   => module,
                        p_action   => action);
        $else
          log_message(p_level       => 'E',
                      p_str         => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                      p_module      => module,
                      p_action      => action,
                      p_backtrace   => dbms_utility.format_error_backtrace,
                      p_error_stack => dbms_utility.format_error_stack);
        $end
      end if;
      exception
        when others then
          null;
    $else
      null;
    $end
  end e;

  procedure f (s      varchar2,
               p1     varchar2 default null,
               p2     varchar2 default null,
               p3     varchar2 default null,
               p4     varchar2 default null,
               p5     varchar2 default null,
               p6     varchar2 default null,
               p7     varchar2 default null,
               p8     varchar2 default null,
               p9     varchar2 default null,
               p10    varchar2 default null,
               module varchar2 default null,
               action varchar2 default null)
  is
  begin
    $if logger_conf.fatal $then
      if s is not null then
        $if logger_conf.print_dbms $then
          print_message(p_level    => 'FATAL',
                        p_str      => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                        p_module   => module,
                        p_action   => action);
        $else
          log_message(p_level       => 'F',
                      p_str         => format(s, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10),
                      p_module      => module,
                      p_action      => action,
                      p_backtrace   => dbms_utility.format_error_backtrace,
                      p_error_stack => dbms_utility.format_error_stack);
        $end
      end if;
      exception
        when others then
          null;
    $else
      null;
    $end
  end f;

end logger;
/

show errors
