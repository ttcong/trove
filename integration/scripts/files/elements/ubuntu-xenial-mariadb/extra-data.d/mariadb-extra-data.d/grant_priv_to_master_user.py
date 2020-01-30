import pymysql.cursors
import os.path
connection = pymysql.connect(read_default_file='~/.my.cnf',
                             cursorclass=pymysql.cursors.DictCursor)
try:
 master_user_path = os.path.expanduser("~/master_user")
 if (os.path.exists(master_user_path)):
   with open(master_user_path,"r") as f:
       lines = f.read().splitlines()

       with connection.cursor() as cursor:
         sql = """SELECT SCHEMA_NAME 
           FROM information_schema.SCHEMATA 
           WHERE SCHEMA_NAME NOT LIKE 'mysql' 
             AND SCHEMA_NAME NOT LIKE 'information_schema' 
             AND SCHEMA_NAME NOT LIKE 'sys' 
             AND SCHEMA_NAME NOT LIKE 'performance_schema';"""
         cursor.execute(sql)
         result = cursor.fetchall()
         for master_user in lines:
           path = os.path.expanduser("~/" + master_user + "privs")
           privs = []
           with open(path,'a+') as fp:
             privs = fp.read().splitlines()
             for row in result:
               if row["SCHEMA_NAME"] not in privs:
                 sql = "GRANT ALL PRIVILEGES on " + row["SCHEMA_NAME"] + ".* to '" + master_user + "'@'%' with grant option;"
                 cursor.execute(sql)
                 print("Grant all privielges on database {} for master user: {}".format(row["SCHEMA_NAME"],master_user))
                 fp.write("{}\n".format(row["SCHEMA_NAME"]))
         sql = "flush privileges;"
         cursor.execute(sql)
finally:
      connection.close()