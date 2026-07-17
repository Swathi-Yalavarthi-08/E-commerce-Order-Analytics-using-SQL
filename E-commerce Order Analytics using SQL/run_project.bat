@echo off
echo ===================================================
echo E-commerce Order Analytics - Automated Runner
echo ===================================================
echo.
echo This script assumes 'mysql' is in your system PATH.
echo If it is not, please edit this file and replace 'mysql' with the full path.
echo Example: "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
echo.
set /p User=Enter MySQL Username (usually root): 
echo Enter MySQL Password:
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "01_create_database.sql"
if %errorlevel% neq 0 goto :error
echo [Success] Database Created.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "02_create_staging_tables.sql"
if %errorlevel% neq 0 goto :error
echo [Success] Staging Tables Created.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "03_create_final_tables.sql"
if %errorlevel% neq 0 goto :error
echo [Success] Final Tables Created.

echo.
echo [Action Required] Attempting to Load CSV Data...
echo Ensure paths in '04_import_csv_steps.sql' are correct.
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "04_import_csv_steps.sql"
if %errorlevel% neq 0 goto :error
echo [Success] Data Loaded.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "05_transform_insert.sql"
if %errorlevel% neq 0 goto :error
echo [Success] ETL Transformation Complete.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "06_kpi_queries.sql"
if %errorlevel% neq 0 goto :error
echo [Success] KPI Queries Executed.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "07_advanced_queries.sql"
if %errorlevel% neq 0 goto :error
echo [Success] Advanced Queries Executed.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "08_views.sql"
if %errorlevel% neq 0 goto :error
echo [Success] Views Created.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u %User% -p --local-infile=1 < "09_indexes.sql"
if %errorlevel% neq 0 goto :error
echo [Success] Indexes Added.

echo.
echo ===================================================
echo ALL SCRIPTS EXECUTED SUCCESSFULLY!
echo check the output above.
echo ===================================================
pause
exit /b 0

:error
echo.
echo [ERROR] A script failed to execute. Check the error message above.
pause
exit /b 1
