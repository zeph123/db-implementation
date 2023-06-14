
# Baza danych Microsoft SQL Server

### Wykonywane instrukcje z poziomu Query Console

1. Utworzenie bazy danych z określonym zestawem znaków (ang. character set) 
i sortowaniem (ang. collation).

```
CREATE DATABASE db_test 
    COLLATE Polish_100_CI_AI_SC_UTF8;

ALTER DATABASE db_test 
    COLLATE Polish_100_CI_AI_SC_UTF8;

# Sprawdzenie, czy zmiany zostały wprowadzone:

SELECT name, collation_name
    FROM sys.databases
    WHERE name = 'db_test';
```

2. Utworzenie użytkownika z identyfikującym go hasłem, 
nadanie użytkownikowi pełnych uprawnień do bazy danych

```    
USE db_test;

CREATE LOGIN loginAdmin
    WITH PASSWORD = 'WVN4ENBz9pmQ7GW32cSXhTEFga54cV3k',
        DEFAULT_DATABASE = db_test;

USE db_test;

CREATE USER admin FOR LOGIN loginAdmin;

EXEC sp_addrolemember 'db_owner', 'admin';

USE master;

GRANT ALTER SERVER STATE TO loginAdmin; 
```

**UWAGA!**

Od tego momentu można zalogować się jako nowo utworzony użytkownik: `admin`, 
jako dane logowania należy podać utworzony login : `loginAdmin`

3. Utworzenie struktury bazy danych

Instrukcje znajdują się w katalogu `/mssql-server-db` w pliku `createDb.sql`

4. Wypełnienie bazy danych

Skrypt Python `insert_data.py` w katalogu `/mssql-server-db`

Wypełnianie bazy danych danymi dla:
* 1 000 tytułów,
* 10 000 tytułów,
* 100 000 tytułów,
* 1 000 000 tytułów
