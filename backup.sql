-- backup.sql
-- Script to perform a full database backup

USE [master];
GO

-- Define variables for the database name and backup directory
DECLARE @DatabaseName NVARCHAR(255) = 'YourDatabaseName';
DECLARE @BackupDirectory NVARCHAR(255) = 'C:\Backups\';
DECLARE @BackupFile NVARCHAR(255);

-- Construct the backup file path
SET @BackupFile = @BackupDirectory + @DatabaseName + '_Full_' + CONVERT(VARCHAR(20), GETDATE(), 112) + '.bak';

-- Perform the full database backup
BACKUP DATABASE @DatabaseName
TO DISK = @BackupFile
WITH NOFORMAT, NOINIT,
NAME = @DatabaseName + ' Full Database Backup',
SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO
