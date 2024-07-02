-- index_optimization.sql
-- Script to reorganize and rebuild indexes

USE [YourDatabaseName];
GO

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
GO
