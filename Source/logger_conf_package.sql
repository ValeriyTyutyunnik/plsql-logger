create or replace package logger_conf as
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

  --  Change true/false value and recompile this package to enable or disable logger level
  info                constant boolean := false;
  trace               constant boolean := false;
  warning             constant boolean := false;
  error               constant boolean := true;
  fatal               constant boolean := true;

  -- print dbms_output (true) or save log (false) in logger_logs table in autonomius transaction
  print_dbms          constant boolean := false;

  -- It's possible to change this settings for your session withount package compilation:
  print_time          boolean := true;
  print_level         boolean := true;
  print_module_action boolean := true;
  print_backtrace     boolean := true;
  print_error_stack   boolean := true;
  timestamp_mask      varchar2(100) not null := 'hh24:mi:ss.ff3';

end logger_conf;
/

show errors
