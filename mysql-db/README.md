
# Baza danych MySQL

### Wykonywane instrukcje z poziomu Query Console

**UWAGA!**

Aby wprowadzić następujące zmiany należy zalogować się do bazy danych 
jako użytkownik: `root`

1. Utworzenie schematu bazy danych z określonym zestawem znaków (ang. character set) 
i sortowaniem (ang. collation), jeśli schemat został utworzony w trakcie uruchamiania
kontenera bazy danych to należy dokonać w nim odpowiednich zmian

```
CREATE SCHEMA IF NOT EXISTS db_test
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_pl_0900_ai_ci;

ALTER SCHEMA db_test
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_pl_0900_ai_ci;

# Sprawdzenie, czy zmiany zostały wprowadzone:

SELECT DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'db_test';
```

2. Utworzenie użytkownika z identyfikującym go hasłem, 
nadanie użytkownikowi pełnych uprawnień do bazy danych

```
# Ustawić w przypadku, gdy wystąpi poniższy błąd:
# [HY000][1819] Your password does not satisfy the current policy requirements
SET GLOBAL validate_password.policy=2;
# Przejść do maszyny wirtualnej MySQL_VM, zalogować się jako root do bazy danych, następnie zmienić politykę walidacji haseł na 2 - STRONG.
zygmunt@mysql-vm:~$ sudo mysql -u root -p
mysql> SET GLOBAL validate_password.policy=2;
mysql> exit


CREATE USER IF NOT EXISTS
    'admin'@'%'
    IDENTIFIED BY 'E&KeR=k*%a$w_5w4@mK9n&TjNS-dUcq4';

CREATE USER IF NOT EXISTS
    'admin'@'localhost'
    IDENTIFIED BY 'E&KeR=k*%a$w_5w4@mK9n&TjNS-dUcq4';

GRANT ALL PRIVILEGES
    ON db_test.*
    TO 'admin'@'%', 'admin'@'localhost'
    WITH GRANT OPTION;

GRANT RELOAD 
    ON *.*
    TO 'admin'@'%', 'admin'@'localhost';
```

**UWAGA!**

Od tego momentu można zalogować się jako nowo utworzony użytkownik: `admin`

3. Utworzenie struktury bazy danych

Instrukcje znajdują się w katalogu `/mysql-db` w pliku `createDb.sql`

4. Wypełnienie bazy danych

Skrypt Python `insert_data.py` w katalogu `/mysql-db`

Wypełnianie bazy danych danymi dla:
* 1 000 tytułów,
* 10 000 tytułów,
* 100 000 tytułów,
* 1 000 000 tytułów
