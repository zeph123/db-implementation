
# Baza danych Oracle - VM VirtualBox

## Przydzielone zasoby sprzętowe

| Nazwa zasobu            | Przydział                                                                                                                     |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| Liczba rdzeni procesora | 2                                                                                                                             |
| Dysk                    | Kontroler SATA (ang. Serial ATA), typ VDI (ang. Virtual Disk Image), pojemność 30 GB, dynamiczny sposób przydzielania pamięci |
| Pamięć RAM              | 4 GB (4096 MB)                                                                                                                |

## Implementacja

Oprogramowanie wykorzystane do utworzenia instancji maszyny wirtualnej 
- Oracle VM VirtualBox w wersji 7.0.6. 

| Typ                | Nazwa          | Wersja                      |
|--------------------|----------------|-----------------------------|
| System operacyjny  | Oracle Linux 8 | 8.7 (R8-U7-x86_64)          |
| Serwer bazy danych | Oracle         | 21.3.0 XE (Express Edition) |

### Utworzenie maszyny wirtualnej - ustawienia:

1. Zakładka Name and Operating System
* Nazwa: Oracle_VM
* Folder: ..\VirtualBox VMs\
* ISO Image: ..\VirtualBox VMs\OracleLinux-R8-U7-x86_64-dvd.iso
* Typ: Linux
* Wersja: Oracle Linux 8.x (64-bit)

2. Zakładka Hardware
* RAM: 4096 MB
* Processors: 2

3. Zakładka Hard Disk
* Hard Disk File Location and Size: 
  * Lokalizacja: domyślnie
  * Rozmiar: 30,00 GB

### Pierwsze uruchomienie - konfiguracja:

* Język: Polski (Polish) -> Polski (Polska)
* Konfiguracja: 
  * Lokalizacja 
    * Klawiatura: Polski 
    * Obsługa języków: Polski (Polska)
    * Strefa czasowa: Europa/Warszawa
  * Oprogramowanie 
    * Źródło instalacji: Lokalny nośnik
    * Wybór oprogramowania: Server
    * System
      * Miejsce docelowe: Wybrano automatyczne partycjonowanie
      * KDUMP: KDUMP is enabled
      * Sieć i nazwa: 
        * Połączono przewodowo - Ethernet (enp0s3)
        * Nazwa komputera: oracle-vm
      * Zasady bezpieczeństwa: Nie wybrano profilu
  * Ustawienia użytkownika
    * Hasło roota: root
    * Utworzenie użytkownika: 
      * Imię i nazwisko: Zygmunt
      * Nazwa użytkownika: zygmunt
      * Ustawienie tego użytkownika jako administratora: Zaznaczone
      * Wymaganie hasła do użycia tego konta: Zaznaczone
      * Hasło: root

### Instalacja serwera Oracle:

Instalacja bibliotek

```
sudo dnf update && sudo dnf upgrade -y
sudo dnf install epel-release -y
sudo dnf install ufw -y
sudo systemctl disable firewalld

# wygenerowanie kluczy ssh
ssh-keygen

sudo ufw enable
sudo ufw allow ssh

sudo service sshd status
sudo ufw status
```

Oracle - instalacja + konfiguracja

```
wget https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm
sudo dnf install oracle-database-preinstall-21c -y
sudo dnf localinstall oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm -y

sudo /etc/init.d/oracle-xe-21c configure
####################################################
SYS, SYSTEM, PDBADMIN password: ax24cvH8
####################################################

sudo nano ~/.bash_profile
####################################################
export ORACLE_SID=XE
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE
export ORACLE_BASE_HOME=/opt/oracle/homes/OraDBHome21cXE
export PATH=$PATH:$ORACLE_HOME/bin
####################################################

sudo nano /etc/oratab
####################################################
XE:/opt/oracle/product/21c/dbhomeXE:Y
####################################################

sudo systemctl daemon-reload
sudo systemctl enable oracle-xe-21c
sudo systemctl start oracle-xe-21c

sudo systemctl status oracle-xe-21c
lsnrctl status
```

Utworzenie usługi uruchamiającej firewall

```
sudo nano /etc/systemd/system/ufw.service
####################################################
[Unit]
Description=Enable ufw (firewall)

[Service]
Type=oneshot
ExecStart=/etc/ufw.service start

[Install]
WantedBy=multi-user.target
####################################################
```

Skrypt uruchamiający firewall

```
sudo nano /etc/ufw.service
####################################################
#!/bin/sh

ufw enable
exit 0
####################################################
```

Nadanie uprawnień, restart deamona i aktywowanie usługi

```
sudo chmod +x /etc/ufw.service

sudo systemctl daemon-reload
sudo systemctl enable ufw.service
sudo systemctl start ufw.service

sudo systemctl status ufw.service
sudo ufw status
```


Ponowne uruchomienie, wystawienie portów

```
sudo ufw allow in on enp0s3 to any port 1521
sudo ufw status

sudo systemctl status oracle-xe-21c
lsnrctl status
```

Wyłącz maszynę, przejdź do ustawień

* Zakładka Sieć
  * Wybierz Karta 1
  * Wybierz przekierowanie portów
  * Dodaj nową regułę przekierowania portów
    * Nazwa: OracleDB XE Server
    * Protokół: TCP
    * IP hosta: 127.0.0.1
    * Port hosta: 1522
    * IP gościa: -
    * Port gościa: 1521
  * Dodaj nową regułę przekierowania portów
    * Nazwa: SSH
    * Protokół: TCP
    * IP hosta: 127.0.0.1
    * Port hosta: 2227
    * IP gościa: -
    * Port gościa: 22

Włącz maszynę, Gotowe.

Połączenie z bazą danych (w DataGrip):
- Host: 127.0.0.1
- Port: 1522
- User: system
- Password: ax24cvH8

Połączenie z maszyną wirtualną (z systemu Windows) w terminalu:
ssh zygmunt@127.0.0.1 -p 2227

Dalsze instrukcje do wykonania znajdują się w pliku `README.md` w katalogu `/oracle-db`
