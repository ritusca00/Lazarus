# -*- coding: utf-8 -*-
"""
Created on Wed Jan 23 19:35:46 2019

@author: blizn
"""

import os

# default values
DEFAULT_MAIN_USER = "C##HR"
DEFAULT_MAIN_PASSWORD = "Rituscaakiraly99"
DEFAULT_CONNECT_STRING = "localhost/orcl"

# values that will be used are the default values unless environment variables
# have been set as noted above
MAIN_USER = os.environ.get("CX_ORACLE_SAMPLES_MAIN_USER", DEFAULT_MAIN_USER)
MAIN_PASSWORD = os.environ.get("CX_ORACLE_SAMPLES_MAIN_PASSWORD",
        DEFAULT_MAIN_PASSWORD)
CONNECT_STRING = os.environ.get("CX_ORACLE_SAMPLES_CONNECT_STRING",
        DEFAULT_CONNECT_STRING)

# calculated values based on the values above
MAIN_CONNECT_STRING = "%s/%s@%s" % (MAIN_USER, MAIN_PASSWORD, CONNECT_STRING)
DRCP_CONNECT_STRING = MAIN_CONNECT_STRING + ":pooled"