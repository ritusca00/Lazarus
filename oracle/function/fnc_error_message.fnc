CREATE OR REPLACE FUNCTION fnc_error_message(p_emid NUMBER) RETURN VARCHAR2 AS
   CO_name CONSTANT VARCHAR2(30) := 'fnc_error_message';
   l_return VARCHAR2(4000);
BEGIN

   SELECT em.error_message INTO l_return FROM errors_message em WHERE em.emid = p_emid;

   RETURN l_return;

EXCEPTION
   WHEN OTHERS THEN
      pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                 p_message          => 'Egyéb hiba, kérlek keresd az IT-t!');
   
END fnc_error_message;
/
