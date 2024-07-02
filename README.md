# SQL Server Maintenance Plans

## Overview

This project focuses on creating and managing SQL Server maintenance plans for regular database maintenance. The maintenance plans include backups, integrity checks, index optimization, and automated execution schedules to ensure the database remains healthy, optimized, and recoverable.

## Technologies

- SQL Server

## Key Features

- Maintenance plans for regular backups
- Database integrity checks
- Index optimization
- Automated execution schedules

## Project Structure

```
sql-server-maintenance-plans/
├── scripts/
│   ├── backup.sql
│   ├── integrity_check.sql
│   ├── index_optimization.sql
│   ├── maintenance_plan.xml
├── docs/
│   ├── setup_guide.md
│   ├── maintenance_guide.md
│   ├── schedule_guide.md
├── config/
│   ├── sqlcmd_vars.sql
├── README.md
└── LICENSE
```

## Instructions

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/your-username/sql-server-maintenance-plans.git
cd sql-server-maintenance-plans
```

### 2. Set Up SQL Server Maintenance Plans

Use the provided SQL scripts to set up maintenance plans for backups, integrity checks, and index optimization.

#### Backup Script: `backup.sql`

```sql
-- backup.sql
-- Script to perform a full database backup

BACKUP DATABASE [YourDatabaseName]
TO DISK = N'C:\Backups\YourDatabaseName_Full.bak'
WITH NOFORMAT, NOINIT,
NAME = N'YourDatabaseName-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD, STATS = 10;
```

#### Integrity Check Script: `integrity_check.sql`

```sql
-- integrity_check.sql
-- Script to perform database integrity checks

DBCC CHECKDB ([YourDatabaseName]) WITH NO_INFOMSGS, ALL_ERRORMSGS;
```

#### Index Optimization Script: `index_optimization.sql`

```sql
-- index_optimization.sql
-- Script to rebuild and reorganize indexes

USE [YourDatabaseName];

-- Reorganize indexes with fragmentation < 30%
DECLARE @TableName NVARCHAR(255);

DECLARE TableCursor CURSOR FOR
SELECT QUOTENAME(OBJECT_SCHEMA_NAME([object_id])) + '.' + QUOTENAME(OBJECT_NAME([object_id]))
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10 AND avg_fragmentation_in_percent < 30;

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('ALTER INDEX ALL ON ' + @TableName + ' REORGANIZE');
    FETCH NEXT FROM TableCursor INTO @TableName;
END;

CLOSE TableCursor;
DEALLOCATE TableCursor;

-- Rebuild indexes with fragmentation >= 30%
DECLARE @TableName2 NVARCHAR(255);

DECLARE TableCursor2 CURSOR FOR
SELECT QUOTENAME(OBJECT_SCHEMA_NAME([object_id])) + '.' + QUOTENAME(OBJECT_NAME([object_id]))
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent >= 30;

OPEN TableCursor2;
FETCH NEXT FROM TableCursor2 INTO @TableName2;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('ALTER INDEX ALL ON ' + @TableName2 + ' REBUILD');
    FETCH NEXT FROM TableCursor2 INTO @TableName2;
END;

CLOSE TableCursor2;
DEALLOCATE TableCursor2;
```

#### Maintenance Plan XML: `maintenance_plan.xml`

This XML file defines the maintenance plan in SQL Server Management Studio (SSMS). You can import this file to create a comprehensive maintenance plan.

```xml
<!-- maintenance_plan.xml -->
<MaintenancePlan>
  <!-- Define your maintenance plan tasks here -->
  <!-- This is a placeholder for an actual maintenance plan XML -->
</MaintenancePlan>
```

### 3. Configure SQLCMD Variables

Use the `sqlcmd_vars.sql` file to define SQLCMD variables for dynamic script execution.

#### Configuration File: `sqlcmd_vars.sql`

```sql
-- sqlcmd_vars.sql
-- Define SQLCMD variables

:setvar DatabaseName "YourDatabaseName"
:setvar BackupDirectory "C:\Backups"
```

### 4. Documentation

#### Setup Guide

`docs/setup_guide.md`

```markdown
# Setup Guide

## Overview

This guide provides step-by-step instructions for setting up SQL Server maintenance plans.

## Steps

1. Execute the `backup.sql` script to set up full database backups.
2. Execute the `integrity_check.sql` script to set up database integrity checks.
3. Execute the `index_optimization.sql` script to set up index optimization.
4. Import the `maintenance_plan.xml` file in SQL Server Management Studio (SSMS) to create a comprehensive maintenance plan.
```

#### Maintenance Guide

`docs/maintenance_guide.md`

```markdown
# Maintenance Guide

## Overview

This guide provides instructions for managing and maintaining SQL Server maintenance plans.

## Tasks

1. Regularly review backup logs to ensure successful backups.
2. Monitor database integrity check results for any errors.
3. Review index optimization reports to ensure indexes are properly maintained.
```

#### Schedule Guide

`docs/schedule_guide.md`

```markdown
# Schedule Guide

## Overview

This guide provides instructions for scheduling SQL Server maintenance plans.

## Steps

1. Open SQL Server Management Studio (SSMS).
2. Navigate to SQL Server Agent and create new jobs for each maintenance task.
3. Set up schedules for each job to automate execution (e.g., daily, weekly).
4. Verify that the jobs are running as expected and review the logs regularly.
```

### Conclusion

By following these steps, you can set up and manage comprehensive SQL Server maintenance plans using the provided scripts and configurations. Regular backups, integrity checks, and index optimization will ensure your database remains healthy, optimized, and recoverable.

## Contributing

We welcome contributions to improve this project. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

Thank you for using the SQL Server Maintenance Plans project! We hope this guide helps you implement a robust maintenance strategy for your SQL Server databases.
