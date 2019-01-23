CREATE OR REPLACE PROCEDURE pcd_add_new_working_calendar(p_years NUMBER) AS

   CO_name CONSTANT VARCHAR2(30) := 'pcd_add_new_working_calendar';
   v_date_exist NUMBER;
   e_year_exists EXCEPTION;
BEGIN
   SELECT COUNT(1)
     INTO v_date_exist
     FROM working_calendar cal
    WHERE cal.calendar_year = p_years;

   IF v_date_exist = 0
   THEN
   
      FOR rec IN (SELECT to_char(dt,
                                 'YYYY') years,
                         to_char(dt,
                                 'MM') months,
                         to_char(dt,
                                 'DD') days
                    FROM (SELECT to_date(p_years || '.01.01',
                                         'YYYY.MM.DD') + rownum - 1 dt
                            FROM dual
                          CONNECT BY LEVEL <= to_date(p_years || '.12.31',
                                                      'YYYY.MM.DD') -
                                     to_date(p_years || '.01.01',
                                                      'YYYY.MM.DD') + 1))
      LOOP
      
         INSERT INTO working_calendar
            (calendar_year,
             calendar_month,
             calendar_day)
         VALUES
            (rec.years,
             rec.months,
             rec.days);
      
      END LOOP;
      COMMIT;
   ELSE
      RAISE e_year_exists;
   END IF;

EXCEPTION
   WHEN e_year_exists THEN
      pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                 p_message          => fnc_error_message(10) ||
                                                       ' p_years=' || p_years);
   WHEN OTHERS THEN
      pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                 p_message          => fnc_error_message(2) || ' p_years=' ||
                                                       p_years);
   
END;
/
