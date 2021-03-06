CREATE OR REPLACE PROCEDURE pcd_add_new_period(p_start_date      DATE,
                                               p_interval_months NUMBER) AS

   v_end_date DATE := add_months(p_start_date,
                                 p_interval_months) - 1;
   v_diff_day NUMBER;

   v_period_exists NUMBER;
   e_period_exists EXCEPTION;
BEGIN

   SELECT COUNT(1)
     INTO v_period_exists
     FROM WORKING_PERIOD cal
    WHERE cal.period_start = p_start_date;

   IF v_period_exists = 0
   THEN
      SELECT COUNT(1)
        INTO v_diff_day
        FROM working_calendar cal
       WHERE to_date(cal.calendar_year || '.' || cal.calendar_month || '.' ||
                     cal.calendar_day,
                     'YYYY.MM.DD') BETWEEN p_start_date AND v_end_date
         AND cal.day_type = 1;
   
      INSERT INTO working_period
         (period_start,
          period_end,
          plan_difference_day,
          plan_difference_hours)
      VALUES
         (p_start_date,
          v_end_date,
          v_diff_day,
          v_diff_day * 8);
      COMMIT;
   
   ELSE
      RAISE e_period_exists;
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
