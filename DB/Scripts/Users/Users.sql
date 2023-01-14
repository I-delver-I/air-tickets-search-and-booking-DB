USE air_tickets_search_and_booking;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'user')
BEGIN
    CREATE USER [user] FOR LOGIN [user]
    EXEC sp_addrolemember 'db_user', 'user'
END;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'worker')
BEGIN
    CREATE USER worker FOR LOGIN worker
    EXEC sp_addrolemember 'db_worker', 'worker'
END;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'administrator')
BEGIN
    CREATE USER administrator FOR LOGIN administrator
    EXEC sp_addrolemember 'db_administrator', 'administrator'
END;