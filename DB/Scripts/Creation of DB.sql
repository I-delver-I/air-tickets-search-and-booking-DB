USE master;

CREATE DATABASE air_tickets_search_and_booking;

SELECT name, size, size*1.0/128 AS [Size in MBs]
FROM sys.master_files
WHERE name = N'air_tickets_search_and_booking';