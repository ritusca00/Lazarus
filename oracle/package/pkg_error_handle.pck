CREATE OR REPLACE PACKAGE pkg_error_handle IS

   -- Author  : HU0897
   -- Created : 2015.06.18. 11:23:26
   -- Purpose : Package for error handling in Exceptions
   TYPE t_rec IS RECORD(
      --LINE BINARY_INTEGER
      schema_name VARCHAR2(30),
      unit_name   VARCHAR2(30),
      unit_type   VARCHAR2(30));
   TYPE t_call_stack_tab IS TABLE OF t_rec INDEX BY PLS_INTEGER;

   -- Public function and procedure declarations

   PROCEDURE log_error(p_inside_unit_name VARCHAR2,
                       p_message          VARCHAR2 DEFAULT NULL);

END pkg_error_handle;
/
CREATE OR REPLACE PACKAGE BODY pkg_error_handle IS

   FUNCTION call_stack_string_to_tab(p_delimiter IN VARCHAR2 DEFAULT chr(10))
      RETURN t_call_stack_tab AS
   
      CO_HEADLINES CONSTANT PLS_INTEGER := 3;
   
      v_call_stack VARCHAR2(4000) := dbms_utility.format_call_stack;
   
      l_call_stack_tab t_call_stack_tab;
   BEGIN
      WITH t AS
       (SELECT v_call_stack AS m FROM dual),
      stack_rows AS
       (SELECT LEVEL AS rn,
               regexp_substr(m, '[^' || p_delimiter || ']+', 1, LEVEL) AS rw
          FROM t
        CONNECT BY LEVEL < = regexp_count(m, p_delimiter) + 1),
      detail AS
       (SELECT rn,
               substr(rw, instr(rw, '  ', -1, 1) + 2) data,
               substr(rw, instr(rw, '  ', -1, 2) + 2,
                      instr(rw, '  ', -1, 1) - instr(rw, '  ', -1, 2) - 1) AS line
          FROM stack_rows
         WHERE rn > CO_HEADLINES),
      full_name_and_type AS
       (SELECT rn,
               CASE
                  WHEN data != 'anonymous block' THEN
                   substr(data, instr(data, ' ', -1, 1) + 1)
                  ELSE
                   NULL
               END AS full_name,
               CASE
                  WHEN data != 'anonymous block' THEN
                   upper(substr(data, 1, instr(data, ' ', -1, 1) - 1))
                  ELSE
                   upper(data)
               END AS unit_type
          FROM detail)
      SELECT substr(full_name, 1, instr(full_name, '.', 1, 1) - 1) AS schema_name,
             --     substr(full_name, instr(full_name, '.', 1, 1) + 1) AS unit_name,
             substr(full_name, instr(full_name, '.', 1) + 1,
                    instr(full_name, '.', 1, 2) - instr(full_name, '.', 1) - 1) AS unit_name,
             unit_type
      
        BULK COLLECT
        INTO l_call_stack_tab
        FROM full_name_and_type;
   
      RETURN l_call_stack_tab;
   END;

   PROCEDURE parse_call_stack(p_call_stack_row   IN t_call_stack_tab,
                              p_inside_unit_name IN OUT VARCHAR2,
                              p_schema_name      OUT VARCHAR2,
                              p_unit_name        OUT VARCHAR2,
                              p_unit_type        OUT VARCHAR2,
                              p_inside_unit_type OUT VARCHAR2) AS
      CO_DEPTH CONSTANT PLS_INTEGER := 3;
   
      v_full_unit_type VARCHAR2(30);
   BEGIN
   
      v_full_unit_type := p_call_stack_row(CO_DEPTH).unit_type;
      p_schema_name    := p_call_stack_row(CO_DEPTH).schema_name;
      p_unit_name      := p_call_stack_row(CO_DEPTH).unit_name;
      p_unit_type := CASE
                        WHEN instr(v_full_unit_type, ' ', 1, 1) > 0 THEN
                         substr(v_full_unit_type, 1, instr(v_full_unit_type, ' ', 1, 1))
                        ELSE
                         v_full_unit_type
                     END;
   
      IF p_unit_type <> v_full_unit_type
      THEN
         SELECT upper(regexp_substr(upper(text), 'FUNCTION|PROCEDURE'))
           INTO p_inside_unit_type
           FROM dba_source
          WHERE NAME = p_unit_name
            AND TYPE = v_full_unit_type
            AND owner = p_schema_name
            AND upper(text) LIKE '%' || p_inside_unit_name || '%'
            AND regexp_like(upper(text), 'FUNCTION|PROCEDURE');
      ELSE
         p_inside_unit_name := NULL;
         p_inside_unit_type := NULL;
      END IF;
   
   END;

   PROCEDURE log_error(p_inside_unit_name VARCHAR2,
                       p_message          VARCHAR2 DEFAULT NULL) AS
   
      PRAGMA AUTONOMOUS_TRANSACTION;
   
      v_unit_type        VARCHAR2(30);
      v_unit_name        VARCHAR2(30);
      v_schema_name      VARCHAR2(30);
      v_inside_unit_type VARCHAR2(30);
      v_inside_unit_name VARCHAR2(30) := upper(p_inside_unit_name);
      v_message          VARCHAR2(4000);
   
   BEGIN
   
      parse_call_stack(call_stack_string_to_tab, v_inside_unit_name, v_schema_name,
                       v_unit_name, v_unit_type, v_inside_unit_type);
   
      v_message := dbms_utility.format_error_backtrace || chr(10) ||
                   dbms_utility.format_error_stack;
   
      INSERT INTO errors_log
         (unit_type,
          unit_name,
          inside_unit_type,
          inside_unit_name,
          error_message,
          created_by,
          creation_date,
          unique_message)
      VALUES
         (v_unit_type,
          v_unit_name,
          v_inside_unit_type,
          v_inside_unit_name,
          v_message,
          upper(sys_context('USERENV', 'OS_USER')),
          SYSDATE,
          p_message);
      COMMIT;
   END;

END pkg_error_handle;

--log tab: id, unit_type(package/procedure/function...), unit_name, inside_unit_type, inside_unit_name, backtrace_error, created_by, creation_date
/
