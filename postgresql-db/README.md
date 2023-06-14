
# Baza danych PostgreSQL

### Przed uruchomieniem kontenera

W pierwszej kolejności należy zaktualizować ustawienia regionalne (językowe) - `locale`:

```
# Sprawdzenie, jakie ustawienia są dostępne na maszynie Ubuntu-20.04:
locale -a

# Instalacja, dodanie ustawień dla języka polskiego:
sudo apt-get install language-pack-pl
sudo locale-gen pl_PL
sudo locale-gen pl_PL.utf8

# Aktualizacja ustawień językowych:
sudo update-locale 

# Ponowna weryfikacja dostępnych ustawień językowych:
locale -a
```

### Wykonywane instrukcje z poziomu Query Console

**UWAGA!**

Aby wprowadzić następujące zmiany należy zalogować się do bazy danych 
jako użytkownik: `admin`, który jest zdefiniowany w pliku .env.

1. Utworzenie bazy danych z określonym zestawem znaków (ang. character set) 
i sortowaniem (ang. collation).

```
CREATE DATABASE db_test
    TEMPLATE 'template0'
    ENCODING 'UTF8'
    LC_COLLATE 'pl_PL.utf8'
    LC_CTYPE 'pl_PL.utf8';
    
LUB

CREATE DATABASE db_test
    TEMPLATE 'template0'
    ENCODING 'UTF8'
    LOCALE 'pl_PL.utf8';
  
# Sprawdzenie, czy zmiany zostały wprowadzone:

SHOW server_encoding;
SHOW lc_collate;
SHOW lc_ctype;
```

**UWAGA !** 

PostgreSQL nie zezwala na zmianę zmiennych: server_encoding, 
lc_collate, lc_ctype dla utworzonej już bazy danych.


2. Utworzenie użytkownika z identyfikującym go hasłem, 
nadanie użytkownikowi pełnych uprawnień do bazy danych

``` 
CREATE USER admin
    WITH PASSWORD 'AP2s6ULM&KHZLqgHTaK55edLExt&3S+N';

ALTER USER admin WITH CREATEDB;
ALTER USER admin WITH CREATEROLE;
ALTER USER admin WITH LOGIN;
ALTER USER admin WITH SUPERUSER;

GRANT ALL PRIVILEGES
    ON DATABASE db_test
    TO admin;

GRANT ALL PRIVILEGES
    ON SCHEMA information_schema
    TO admin;

GRANT ALL PRIVILEGES
    ON SCHEMA pg_catalog
    TO admin;

GRANT ALL PRIVILEGES
    ON SCHEMA public
    TO admin;
```

**UWAGA!**

Od tego momentu można zalogować się jako nowo utworzony użytkownik: `admin`

3. Utworzenie struktury bazy danych

Instrukcje znajdują się w katalogu `/postgresql-db` w pliku `createDb.sql`

4. Wypełnienie bazy danych

Skrypt Python `insert_data.py` w katalogu `/postgresql-db`

Wypełnianie bazy danych danymi dla:
* 1 000 tytułów,
* 10 000 tytułów,
* 100 000 tytułów,
* 1 000 000 tytułów
