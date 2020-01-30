#Get Password
os_admin_pass=$(awk 'BEGIN{FS=" = "} {if ($1 == "password") print $2}' /var/lib/trove/.my.cnf)
root_pass=$(awk 'BEGIN{FS=" = "} {if ($1 == "password") print $2}' /root/.my.cnf)

echo "skip-grant-tables" >> /etc/mysql/conf.d/01-dbaas-custom.cnf
rm -f /var/lib/mysql/data/mysql/user.TRG
rm -f /var/lib/mysql/data/mysql/proc.TRG
cp /var/lib/trove/import_vdbaas_procedures.sh /var/lib/trove/import_vdbaas_procedures.sh_bk

cat >/var/lib/trove/import_vdbaas_procedures.sh << _EOF_
#!/bin/bash
echo "Do not import vDbaas procedures"
_EOF_
chown mysql:mysql /var/lib/trove/import_vdbaas_procedures.sh
systemctl restart mariadb

mysql -e "DELETE FROM mysql.user WHERE  user = 'root' AND host = 'localhost';"
mysql -e "INSERT INTO mysql.user SET user = 'root', host = 'localhost', password =Password('$root_pass'), Select_priv = 'y',Insert_priv = 'y',Update_priv = 'y',Delete_priv = 'y',Create_priv = 'y',Drop_priv = 'y',Reload_priv = 'y',Shutdown_priv = 'y',Process_priv = 'y',File_priv = 'y',Grant_priv = 'y',References_priv = 'y',Index_priv = 'y',Alter_priv = 'y',Show_db_priv = 'y',Super_priv = 'y',Create_tmp_table_priv = 'y',Lock_tables_priv = 'y',Execute_priv = 'y',Repl_slave_priv = 'y',Repl_client_priv = 'y',Create_view_priv = 'y',Show_view_priv = 'y',Create_routine_priv = 'y',Alter_routine_priv = 'y',Create_user_priv = 'y',Event_priv = 'y',Trigger_priv = 'y',Create_tablespace_priv = 'y',ssl_cipher = '',x509_issuer = '',x509_subject = '';"
mysql -e "DELETE FROM mysql.user WHERE  user = 'os_admin' AND host = '127.0.0.1';"
mysql -e "INSERT INTO mysql.user SET user = 'os_admin', host = '127.0.0.1', password =Password('$os_admin_pass'), Select_priv = 'y',Insert_priv = 'y',Update_priv = 'y',Delete_priv = 'y',Create_priv = 'y',Drop_priv = 'y',Reload_priv = 'y',Shutdown_priv = 'y',Process_priv = 'y',File_priv = 'y',Grant_priv = 'y',References_priv = 'y',Index_priv = 'y',Alter_priv = 'y',Show_db_priv = 'y',Super_priv = 'y',Create_tmp_table_priv = 'y',Lock_tables_priv = 'y',Execute_priv = 'y',Repl_slave_priv = 'y',Repl_client_priv = 'y',Create_view_priv = 'y',Show_view_priv = 'y',Create_routine_priv = 'y',Alter_routine_priv = 'y',Create_user_priv = 'y',Event_priv = 'y',Trigger_priv = 'y',Create_tablespace_priv = 'y',ssl_cipher = '',x509_issuer = '',x509_subject = '';"

systemctl restart mariadb

sed -i '/^skip-grant-tables$/d' /etc/mysql/conf.d/01-dbaas-custom.cnf
mv /var/lib/trove/import_vdbaas_procedures.sh_bk /var/lib/trove/import_vdbaas_procedures.sh
chown mysql:mysql /var/lib/trove/import_vdbaas_procedures.sh
systemctl restart mariadb
