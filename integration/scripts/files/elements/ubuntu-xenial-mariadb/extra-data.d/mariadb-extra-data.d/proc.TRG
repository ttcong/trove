TYPE=TRIGGERS
triggers='CREATE DEFINER=`os_admin`@`127.0.0.1` TRIGGER mysql.block_proc_u BEFORE UPDATE ON proc \nFOR EACH ROW BEGIN \n   IF old.Definer = \'os_admin@127.0.0.1\' THEN \n    SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'CANNOT MODIFY OS_ADMIN OBJECT\';\n   END IF;\nEND' 'CREATE DEFINER=`os_admin`@`127.0.0.1` TRIGGER mysql.block_proc_d BEFORE DELETE on proc \nFOR EACH ROW BEGIN \n   IF old.Definer = \'os_admin@127.0.0.1\' THEN \n    SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'CANNOT MODIFY OS_ADMIN OBJECT\';\n   END IF; \nEND'
sql_modes=1073741824 1073741824
definers='os_admin@127.0.0.1' 'os_admin@127.0.0.1'
client_cs_names='latin1' 'latin1'
connection_cl_names='latin1_swedish_ci' 'latin1_swedish_ci'
db_cl_names='latin1_swedish_ci' 'latin1_swedish_ci'
created=156285809935 156285813550
