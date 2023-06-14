
# Baza danych Oracle

### Przed uruchomieniem kontenera

Utworzyć katalog przechowujący dane z bazy danych 
i nadać mu odpowiednie uprawnienia

```
cd oracle-db
mkdir -p db-data/oradata
chmod 777 db-data/oradata
```

### Wykonywane instrukcje z poziomu Query Console


1. Utworzenie użytkownika z identyfikującym go hasłem, 
nadanie użytkownikowi pełnych uprawnień do bazy danych, 
utworzenie użytkownika jest równoznaczne z utworzeniem 
schematu bazy danych.

```
CREATE USER C##admin
    IDENTIFIED BY Ax8QsHu2mNQ3GT3C
    DEFAULT TABLESPACE USERS
    QUOTA UNLIMITED ON USERS;

GRANT ALL PRIVILEGES
    TO C##admin; 
```

2. Zmiana zestawu znaków (ang. character set), 
sortowania (ang. collation), języka, regionu.

**Nie ma możliwości wprowadzenia zmian w utworzonej bazie danych.**

```
ALTER SESSION SET NLS_COMP = 'LINGUISTIC';
ALTER SESSION SET NLS_SORT = 'POLISH';
ALTER SESSION SET NLS_LANGUAGE = 'POLISH';
ALTER SESSION SET NLS_TERRITORY = 'POLAND';
-- ALTER SESSION SET NLS_NCHAR_CHARACTERSET = 'AL16UTF16';
-- ALTER SESSION SET NLS_CHARACTERSET = 'AL32UTF8';
```

**UWAGA!**

Od tego momentu można zalogować się jako nowo utworzony użytkownik: `C##admin`

3. Utworzenie struktury bazy danych

Instrukcje znajdują się w katalogu `/oracle-db` w pliku `createDb.sql`

4. Wypełnienie bazy danych

Skrypt Python `insert_data.py` w katalogu `/oracle-db`

Wypełnianie bazy danych danymi dla:
* 1 000 tytułów,
* 10 000 tytułów,
* 100 000 tytułów,
* 1 000 000 tytułów
