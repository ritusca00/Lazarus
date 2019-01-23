CREATE OR REPLACE PACKAGE pkg_user IS

   co_email VARCHAR2(50) := '@rinoprod.com';
   -- Author  : BLIZNIK RITA
   -- Created : 2019. 01. 17. 21:16:44
   -- Purpose :

   -------------------------///ADD PROCEDURE\\\-------------------------
   PROCEDURE add_user(p_pwd            VARCHAR2 DEFAULT 'almafa',
                      p_lastname       VARCHAR2,
                      p_firstname      VARCHAR2,
                      p_gender         VARCHAR2,
                      p_birth_date     DATE,
                      p_birth_place    VARCHAR2,
                      p_mother_name    VARCHAR2,
                      p_address_const  VARCHAR2,
                      p_address_temp   VARCHAR2,
                      p_beginning_date DATE,
                      p_status         VARCHAR2 DEFAULT 'VALID',
                      p_posid          NUMBER,
                      p_superior       NUMBER DEFAULT NULL);

   PROCEDURE add_position(p_position_desc  VARCHAR2,
                          p_position_level NUMBER,
                          p_activ_pos      NUMBER DEFAULT 0);

   PROCEDURE add_salary(p_userid NUMBER,
                        p_gross  NUMBER);

   PROCEDURE add_new_position_level(p_position_level_desc VARCHAR2,
                                    p_activ_flag          NUMBER DEFAULT 0);

   PROCEDURE add_attendance(p_userid NUMBER,
                            p_start  DATE DEFAULT to_date(to_char(SYSDATE,
                                                                  
                                                                  'YYYY.MM.DD') ||
                                                          ' 08:00:00',
                                                          'YYYY.MM.DD HH24:MI:SS'),
                            p_end    DATE DEFAULT to_date(to_char(SYSDATE,
                                                                  'YYYY.MM.DD') ||
                                                          ' 16:30:00',
                                                          'YYYY.MM.DD HH24:MI:SS'),
                            p_type   VARCHAR2 DEFAULT 'CONST');

   PROCEDURE add_position_hierarchy(p_child  NUMBER,
                                    p_parent NUMBER DEFAULT NULL);
   -------------------------///MOD USER\\\-------------------------
   PROCEDURE mod_user_new_position(p_userid   NUMBER,
                                   p_newposid NUMBER,
                                   p_type     VARCHAR2);

   PROCEDURE modify_user(p_userid        NUMBER,
                         p_pwd           VARCHAR2 DEFAULT NULL,
                         p_lastname      VARCHAR2 DEFAULT NULL,
                         p_firstname     VARCHAR2 DEFAULT NULL,
                         p_gender        VARCHAR2 DEFAULT NULL,
                         p_birth_date    DATE DEFAULT NULL,
                         p_birth_place   VARCHAR2 DEFAULT NULL,
                         p_mother_name   VARCHAR2 DEFAULT NULL,
                         p_address_const VARCHAR2 DEFAULT NULL,
                         p_address_temp  VARCHAR2 DEFAULT NULL,
                         p_leaving_date  DATE DEFAULT NULL,
                         p_status        VARCHAR2 DEFAULT NULL);

   ---------------///MODIFY PROCEDURE WITHOUT USER\\\------------------
   PROCEDURE modify_position(p_posid NUMBER,
                             p_flag  NUMBER);

END pkg_user;
/
CREATE OR REPLACE PACKAGE BODY pkg_user IS

   PROCEDURE add_user_all AS
   BEGIN
      NULL;
   END;

   --OOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOO

   PROCEDURE add_user(p_pwd            VARCHAR2 DEFAULT 'almafa',
                      p_lastname       VARCHAR2,
                      p_firstname      VARCHAR2,
                      p_gender         VARCHAR2,
                      p_birth_date     DATE,
                      p_birth_place    VARCHAR2,
                      p_mother_name    VARCHAR2,
                      p_address_const  VARCHAR2,
                      p_address_temp   VARCHAR2,
                      p_beginning_date DATE,
                      p_status         VARCHAR2 DEFAULT 'VALID',
                      p_posid          NUMBER,
                      p_superior       NUMBER DEFAULT NULL) AS
   
      co_name           VARCHAR2(30) := 'add_user';
      v_username        VARCHAR2(100) := lower(substr(p_firstname,
                                                      1,
                                                      1) || p_lastname);
      v_email           VARCHAR2(100) := p_lastname || '.' || p_firstname || co_email;
      v_userid          NUMBER;
      v_exists_username NUMBER;
      e_username_is_exists EXCEPTION;
   BEGIN
   
      SELECT COUNT(1)
        INTO v_exists_username
        FROM employee e
       WHERE e.username = v_username;
   
      IF v_exists_username > 0
      THEN
         RAISE e_username_is_exists;
      END IF;
   
      INSERT INTO employee
         (username,
          pwd,
          lastname,
          firstname,
          gender,
          birth_date,
          birth_place,
          mother_name,
          address_const,
          address_temp,
          email,
          beginning_date,
          status,
          posid,
          superior,
          creation_by,
          creation_date,
          last_updated_by,
          last_updated_date)
      VALUES
         (v_username,
          sha256.encrypt(p_pwd),
          p_lastname,
          p_firstname,
          p_gender,
          p_birth_date,
          p_birth_place,
          p_mother_name,
          p_address_const,
          p_address_temp,
          v_email,
          p_beginning_date,
          p_status,
          p_posid,
          p_superior,
          upper(sys_context('USERENV',
                            'OS_USER')),
          SYSDATE,
          upper(sys_context('USERENV',
                            'OS_USER')),
          SYSDATE)
      RETURNING userid INTO v_userid;
      COMMIT;
   
   EXCEPTION
      WHEN e_username_is_exists THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(1));
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' Username=' || v_username);
   END;
   --OOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOO
   PROCEDURE add_new_position_level(p_position_level_desc VARCHAR2,
                                    p_activ_flag          NUMBER DEFAULT 0) AS
      co_name CONSTANT VARCHAR2(30) := 'add_new_position_level';
      v_exists_level NUMBER;
      e_notvalid_activflag EXCEPTION;
      e_notexists_level    EXCEPTION;
   
   BEGIN
   
      SELECT COUNT(1)
        INTO v_exists_level
        FROM position_level pl
       WHERE REPLACE(upper(pl.description),
                     ' ') = REPLACE(upper(p_position_level_desc),
                                    ' ');
   
      IF p_activ_flag NOT IN (0,
                              1)
      THEN
         RAISE e_notvalid_activflag;
      ELSIF v_exists_level > 0
      THEN
         RAISE e_notexists_level;
      ELSE
         INSERT INTO position_level
            (description,
             active)
         VALUES
            (p_position_level_desc,
             p_activ_flag);
         COMMIT;
      END IF;
   
   EXCEPTION
      WHEN e_notvalid_activflag THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(5) || ' flag=' ||
                                                          p_activ_flag);
      WHEN e_notexists_level THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(6) ||
                                                          ' position_level_desc=' ||
                                                          p_position_level_desc);
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' pos_level_desc=' ||
                                                          p_position_level_desc);
   END;
   --OOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOO
   PROCEDURE add_position(p_position_desc  VARCHAR2,
                          p_position_level NUMBER,
                          p_activ_pos      NUMBER DEFAULT 0) AS
   
      CO_name CONSTANT VARCHAR2(30) := 'ADD_POSITION';
      v_exists_pos   NUMBER;
      v_pos_level_id NUMBER;
      e_notexists_level_id EXCEPTION;
      e_notexists_pos      EXCEPTION;
      e_notvalid_activflag EXCEPTION;
   BEGIN
   
      SELECT COUNT(1)
        INTO v_exists_pos
        FROM position p
       WHERE REPLACE(upper(p.description),
                     ' ') = REPLACE(upper(p_position_desc),
                                    ' ');
   
      SELECT COUNT(1)
        INTO v_pos_level_id
        FROM position_level pl
       WHERE pl.levelid = p_position_level;
   
      IF v_exists_pos > 0
      THEN
         RAISE e_notexists_pos;
      ELSIF v_pos_level_id = 0
      THEN
         RAISE e_notexists_level_id;
      ELSIF p_activ_pos NOT IN (0,
                                1)
      THEN
         RAISE e_notvalid_activflag;
      ELSE
         INSERT INTO position
            (description,
             position_level,
             active)
         VALUES
            (p_position_desc,
             p_position_level,
             p_activ_pos);
         COMMIT;
      END IF;
   
   EXCEPTION
      WHEN e_notexists_pos THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(3) ||
                                                          ' position_desc=' ||
                                                          p_position_desc);
      WHEN e_notexists_level_id THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(4) ||
                                                          ' position_desc=' ||
                                                          p_position_desc);
      WHEN e_notvalid_activflag THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(5) ||
                                                          ' position_desc=' ||
                                                          p_position_desc);
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' position_desc=' ||
                                                          p_position_desc);
   END;
   --OOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOOOOooOO
   PROCEDURE mod_user_new_position(p_userid   NUMBER,
                                   p_newposid NUMBER,
                                   p_type     VARCHAR2) AS
      CO_name CONSTANT VARCHAR2(30) := 'add_new_position_to_user';
      v_user_notexists  NUMBER;
      v_posid_notexists NUMBER;
      v_same_posid      NUMBER;
      e_user_notexists  EXCEPTION;
      e_posid_notexists EXCEPTION;
      e_same_posid      EXCEPTION;
   
   BEGIN
      SELECT COUNT(1) INTO v_user_notexists FROM employee e WHERE e.userid = p_userid;
   
      SELECT COUNT(1) INTO v_same_posid FROM employee e WHERE e.posid = p_newposid;
   
      SELECT COUNT(1) INTO v_posid_notexists FROM position p WHERE p.posid = p_newposid;
   
      IF v_user_notexists = 0
      THEN
         RAISE e_user_notexists;
      ELSIF v_same_posid > 0
            AND p_type != 'DELETE'
      THEN
         RAISE e_same_posid;
      ELSIF v_posid_notexists = 0
      THEN
         RAISE e_posid_notexists;
      ELSE
         IF upper(p_type) = 'UPDATE'
         THEN
            UPDATE employee e
               SET e.posid = p_newposid
                  ,e.last_updated_by = CO_name
                  ,e.last_updated_date = SYSDATE
             WHERE e.userid = p_userid;
         ELSIF upper(p_type) = 'DELETE'
         THEN
            UPDATE employee e
               SET e.posid = NULL
                  ,e.last_updated_by = CO_name
                  ,e.last_updated_date = SYSDATE
             WHERE e.userid = p_userid;
         END IF;
         COMMIT;
      
      END IF;
   
   EXCEPTION
      WHEN e_user_notexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(7) ||
                                                          ' userid=' || p_userid);
      WHEN e_same_posid THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(9) ||
                                                          ' newposid=' || p_newposid);
      WHEN e_posid_notexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(8) ||
                                                          ' newposid=' || p_newposid);
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' newposid=' || p_newposid ||
                                                          ' userid=' || p_userid);
      
   END;

   PROCEDURE add_salary(p_userid NUMBER,
                        p_gross  NUMBER) AS
   
      CO_name CONSTANT VARCHAR2(30) := 'add_salary';
      v_user_notexists NUMBER;
      e_user_notexists EXCEPTION;
   
   BEGIN
      SELECT COUNT(1) INTO v_user_notexists FROM employee e WHERE e.userid = p_userid;
   
      IF v_user_notexists = 0
      THEN
         RAISE e_user_notexists;
      ELSE
         INSERT INTO salary
            (userid,
             gross)
         VALUES
            (p_userid,
             p_gross);
      
         COMMIT;
      END IF;
   EXCEPTION
      WHEN e_user_notexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(7) ||
                                                          ' userid=' || p_userid);
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' userid=' || p_userid);
      
   END;

   PROCEDURE add_attendance(p_userid NUMBER,
                            p_start  DATE DEFAULT to_date(to_char(SYSDATE,
                                                                  'YYYY.MM.DD') ||
                                                          ' 08:00:00',
                                                          'YYYY.MM.DD HH24:MI:SS'),
                            p_end    DATE DEFAULT to_date(to_char(SYSDATE,
                                                                  'YYYY.MM.DD') ||
                                                          ' 16:30:00',
                                                          'YYYY.MM.DD HH24:MI:SS'),
                            p_type   VARCHAR2 DEFAULT 'CONST') AS
      CO_name CONSTANT VARCHAR2(30) := 'add_attendance';
      v_user_notexists NUMBER;
      v_today          DATE := trunc(p_start);
      e_user_notexists EXCEPTION;
   BEGIN
      SELECT COUNT(1) INTO v_user_notexists FROM employee e WHERE e.userid = p_userid;
   
      IF v_user_notexists = 0
      THEN
         RAISE e_user_notexists;
      ELSE
         IF upper(p_type) = 'CONST'
         THEN
            INSERT INTO attendance
               (userid,
                plan_start,
                plan_end)
            VALUES
               (p_userid,
                p_start,
                p_end);
         ELSIF upper(p_type) = 'ACTUAL'
         THEN
         
            UPDATE attendance a
               SET a.actual_start = p_start
                  ,a.actual_end = p_end
                  ,a.overtime =
                   (round((p_end - p_start) * 24,
                          2) - 0.5) - a.plan_difference
                  ,a.last_updated_by = CO_name
                  ,a.last_updated_date = SYSDATE
             WHERE a.userid = p_userid
               AND trunc(a.plan_start) = v_today;
         
         END IF;
         COMMIT;
      END IF;
   
   EXCEPTION
      WHEN e_user_notexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(7) ||
                                                          ' userid=' || p_userid);
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' userid=' || p_userid);
      
   END;

   PROCEDURE add_position_hierarchy(p_child  NUMBER,
                                    p_parent NUMBER DEFAULT NULL) AS
      co_name            VARCHAR2(30) := 'add_position_hierarchy';
      v_pair_isexists    NUMBER;
      v_reverse_isexists NUMBER;
      e_pair_isexists    EXCEPTION;
      e_reverse_isexists EXCEPTION;
   
   BEGIN
   
      SELECT COUNT(1)
        INTO v_pair_isexists
        FROM POSITION_HIERARCHY ph
       WHERE ph.child_id = p_child
         AND nvl(ph.parent_id,
                 -1) = nvl(p_parent,
                           -1);
   
      SELECT COUNT(1)
        INTO v_reverse_isexists
        FROM POSITION_HIERARCHY ph
       WHERE ph.child_id = p_parent
         AND nvl(ph.parent_id,
                 -1) = p_child;
   
      IF v_pair_isexists = 0
      THEN
         IF v_reverse_isexists = 0
         THEN
            INSERT INTO POSITION_HIERARCHY
               (CHILD_ID,
                PARENT_ID,
                ACTIVE)
            VALUES
               (p_child,
                p_parent,
                1);
            COMMIT;
         ELSE
            RAISE e_reverse_isexists;
         END IF;
      ELSE
         RAISE e_pair_isexists;
      END IF;
   EXCEPTION
      WHEN e_reverse_isexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => REPLACE(REPLACE(fnc_error_message(12),
                                                                          '<<child>>',
                                                                          p_child),
                                                                  '<<parent>>',
                                                                  p_parent));
      WHEN e_pair_isexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => REPLACE(REPLACE(fnc_error_message(13),
                                                                          '<<child>>',
                                                                          p_child),
                                                                  '<<parent>>',
                                                                  p_parent));
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2));
      
   END;

   PROCEDURE modify_user(p_userid        NUMBER,
                         p_pwd           VARCHAR2 DEFAULT NULL,
                         p_lastname      VARCHAR2 DEFAULT NULL,
                         p_firstname     VARCHAR2 DEFAULT NULL,
                         p_gender        VARCHAR2 DEFAULT NULL,
                         p_birth_date    DATE DEFAULT NULL,
                         p_birth_place   VARCHAR2 DEFAULT NULL,
                         p_mother_name   VARCHAR2 DEFAULT NULL,
                         p_address_const VARCHAR2 DEFAULT NULL,
                         p_address_temp  VARCHAR2 DEFAULT NULL,
                         p_leaving_date  DATE DEFAULT NULL,
                         p_status        VARCHAR2 DEFAULT NULL) AS
   
      co_name              VARCHAR2(30) := 'modify_user';
      v_username_notexists NUMBER;
      e_username_notexists EXCEPTION;
   BEGIN
   
      SELECT COUNT(1)
        INTO v_username_notexists
        FROM employee e
       WHERE e.userid = p_userid;
   
      IF v_username_notexists = 0
      THEN
         RAISE e_username_notexists;
      END IF;
   
      IF p_pwd IS NOT NULL
      THEN
         UPDATE employee e
            SET e.pwd = sha256.encrypt(p_pwd)
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_lastname IS NOT NULL
      THEN
         UPDATE employee e
            SET e.lastname = p_lastname
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_firstname IS NOT NULL
      THEN
         UPDATE employee e
            SET e.firstname = p_firstname
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_gender IS NOT NULL
      THEN
         UPDATE employee e
            SET e.gender = p_gender
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_birth_date IS NOT NULL
      THEN
         UPDATE employee e
            SET e.birth_date = p_birth_date
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_birth_place IS NOT NULL
      THEN
         UPDATE employee e
            SET e.birth_place = p_birth_place
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_mother_name IS NOT NULL
      THEN
         UPDATE employee e
            SET e.mother_name = p_mother_name
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_address_const IS NOT NULL
      THEN
         UPDATE employee e
            SET e.address_const = p_address_const
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_address_temp IS NOT NULL
      THEN
         UPDATE employee e
            SET e.address_temp = p_address_temp
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_leaving_date IS NOT NULL
      THEN
         UPDATE employee e
            SET e.leaving_date = p_leaving_date
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      ELSIF p_status IS NOT NULL
      THEN
         UPDATE employee e
            SET e.status = p_status
               ,e.last_updated_by = CO_name
               ,e.last_updated_date = SYSDATE
          WHERE e.userid = p_userid;
      
      END IF;
      COMMIT;
   
   EXCEPTION
      WHEN e_username_notexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(7) ||
                                                          ' p_userid=' || p_userid);
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' p_userid=' || p_userid);
   END;

   PROCEDURE modify_position(p_posid NUMBER,
                             p_flag  NUMBER) AS
   
      CO_name CONSTANT VARCHAR2(30) := 'modify_position';
      v_pos_notexists NUMBER;
      e_pos_notexists EXCEPTION;
   BEGIN
      SELECT COUNT(1) INTO v_pos_notexists FROM position p WHERE p.posid = p_posid;
   
      IF v_pos_notexists = 0
      THEN
         RAISE e_pos_notexists;
      ELSE
         UPDATE position p
            SET p.active = p_flag
               ,p.last_updated_by = CO_name
               ,p.last_updated_date = SYSDATE
          WHERE p.posid = p_posid;
      
         COMMIT;
      END IF;
   
   EXCEPTION
      WHEN e_pos_notexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(8) ||
                                                          ' posid=' || p_posid);
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' posid=' || p_posid);
      
   END;

   PROCEDURE modify_salary(p_userid NUMBER,
                           p_gross  NUMBER) AS
   
      CO_name CONSTANT VARCHAR2(30) := 'modify_salary';
      v_user_notexists NUMBER;
      e_user_notexists EXCEPTION;
   
   BEGIN
      SELECT COUNT(1) INTO v_user_notexists FROM employee e WHERE e.userid = p_userid;
   
      IF v_user_notexists = 0
      THEN
         RAISE e_user_notexists;
      ELSE
         UPDATE salary s
            SET s.gross = p_gross
               ,s.last_updated_by = CO_name
               ,s.last_updated_date = SYSDATE
          WHERE s.userid = p_userid;
      
         COMMIT;
      END IF;
   EXCEPTION
      WHEN e_user_notexists THEN
         pkg_error_handle.log_error(p_inside_unit_name => CO_name,
                                    p_message          => fnc_error_message(7) ||
                                                          ' userid=' || p_userid);
      WHEN OTHERS THEN
         pkg_error_handle.log_error(p_inside_unit_name => co_name,
                                    p_message          => fnc_error_message(2) ||
                                                          ' userid=' || p_userid);
   END;

   PROCEDURE modify_position_hierarchy AS
   BEGIN
      NULL;
   END;

END pkg_user;
/
