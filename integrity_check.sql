-- integrity_check.sql
-- Script to perform database integrity checks

USE [master];
GO

-- Define variables for the database name
DECLARE @DatabaseName NVARCHAR(255) = 'YourDatabaseName';

-- Perform database integrity check
DBCC CHECKDB (@DatabaseName) WITH NO_INFOMSGS, ALL_ERRORMSGS;
GO
