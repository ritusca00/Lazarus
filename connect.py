# -*- coding: utf-8 -*-
"""
Created on Wed Jan 23 19:34:26 2019

@author: blizn
"""

from __future__ import print_function

import cx_Oracle
import db_config


class oracleConnect(cx_Oracle.Connection):
    def __init__(self):
        connectString = db_config.MAIN_CONNECT_STRING
        print("CONNECT to database")
        return super(oracleConnect, self).__init__(connectString)

    def cursor(self):
        return Cursor(self)


# sample subclassed cursor which overrides the execute() and fetchone()
# methods in order to perform some simple logging
class Cursor(cx_Oracle.Cursor):

    def execute(self, statement, args):
        print("EXECUTE", statement)
        print("ARGS:")
        for argIndex, arg in enumerate(args):
            print("   ", argIndex + 1, "=>", repr(arg))
        return super(Cursor, self).execute(statement, args)

    def fetchone(self):
        print("FETCH ONE")
        return super(Cursor, self).fetchone()
    
    def fetchall(self):
        print("FETCH ONE")
        return super(Cursor, self).fetchall()

# create instances of the subclassed connection and cursor
connection = oracleConnect()
cursor = connection.cursor()

# demonstrate that the subclassed connection and cursor are being used
#cursor.execute("select count(1) from C##HR.Employee e where e.username = :1",(1,))
#count, = cursor.fetchone()
#print("COUNT:", int(count))
    