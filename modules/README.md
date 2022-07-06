## Modules Folder

If module has multiple deployment types add each module here in a subfolder folder. 

Note, root also needs a main.tf which can be empty.


For example, GCP Cloud SQL module would allow deployment of:

- mysql-public
- mysql-private
- mssql-public
- mssql-private
- postgresql-public
- postgresql-private

