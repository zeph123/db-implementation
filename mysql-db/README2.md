
# Baza danych MySQL - VM VirtualBox

## Przydzielone zasoby sprzętowe

| Nazwa zasobu            | Przydział                                                                                                                     |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| Liczba rdzeni procesora | 2                                                                                                                             |
| Dysk                    | Kontroler SATA (ang. Serial ATA), typ VDI (ang. Virtual Disk Image), pojemność 30 GB, dynamiczny sposób przydzielania pamięci |
| Pamięć RAM              | 4 GB (4096 MB)                                                                                                                |

## Implementacja

Oprogramowanie wykorzystane do utworzenia instancji maszyny wirtualnej 
- Oracle VM VirtualBox w wersji 7.0.6. 

| Typ                | Nazwa   | Wersja                    |
|--------------------|---------|---------------------------|
| System operacyjny  | Ubuntu  | 20.04.5 LTS (Focal Fossa) |
| Serwer bazy danych | MySQL   | 8.0.32                    |

### Utworzenie maszyny wirtualnej - ustawienia:

1. Zakładka Name and Operating System
* Nazwa: MySQL_VM
* Folder: ..\VirtualBox VMs\
* ISO Image: ..\VirtualBox VMs\ubuntu-20.04.5-live-server-amd64.iso
* Typ: Linux
* Wersja: Ubuntu 20.04 LTS (Focal Fossa) (64-bit)

2. Zakładka Hardware
* RAM: 4096 MB
* Processors: 2

3. Zakładka Hard Disk
* Hard Disk File Location and Size: 
  * Lokalizacja: domyślnie
  * Rozmiar: 30,00 GB

### Pierwsze uruchomienie - konfiguracja:

* Język: Polski
* Konfiguracja klawiatury:
  * Układ: Polish 
  * Wariant: Polish
* Połączenie sieciowe: domyślnie
* Konfiguracja Proxy: domyślnie
* Skonfiguruj serwer lustrzany archiwum Ubuntu: domyślnie
* Konfiguracja pamięci masowej z przewodnikiem: domyślnie
* Konfiguracja pamięci masowej: domyślnie
* Ustawienia profilu:
  * Imię: Ubuntu
  * Nazwa serwera: mysql-vm
  * Nazwa użytkownika: zygmunt
  * Hasło: root
* Ustawienia SSH: 
  * Zainstaluj serwer SSH: Zaznaczone
  * Importuj tożsamość SSH: Nie
* Polecane snapy serwerowe: domyślnie

### Instalacja serwera MySQL:

Instalacja bibliotek

```
sudo apt update && sudo apt upgrade -y
sudo apt install ufw
sudo apt install net-tools
sudo apt install dpkg

# wygenerowanie kluczy ssh
ssh-keygen

sudo ufw enable
sudo ufw allow ssh

sudo service sshd status
sudo ufw status
```

MySQL - instalacja + konfiguracja

```
wget https://dev.mysql.com/get/mysql-apt-config_0.8.24-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.24-1_all.deb

####################################################
Wybrane parametry:
- MySQL Server & Cluster (Currently selected: mysql-8.0)
- MySQL Tools & Connectors (Currenlty selected: Enabled)
- MySQL Preview Packages (Currently selected: Disabled)
####################################################

sudo apt update && sudo apt upgrade -y

sudo apt install mysql-server

####################################################
Wybrane parametry:
- Root password: 8wnK2FR9Zb
- Use strong password encryption (recommended)
####################################################

sudo systemctl status mysql
mysql --version

sudo mysql_secure_installation

####################################################

VALIDATE PASSWORD COMPONENT can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD component?
Press y|Y for Yes, any other key for No: y

LOW    Length >= 8
MEDIUM Length >= 8, numeric, mixed case, and special characters
STRONG Length >= 8, numeric, mixed case, special characters and dictionary file
Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 2

Estimated strength of the password: 50
Change the password for root ? ((Press y|Y for Yes, any other key for No) : y

New password: 8wnK20R9Z$
Re-enter new password: 8wnK20R9Z$

Estimated strength of the password: 100
Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y

By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.
Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
Success.

Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.
Disallow root login remotely? (Press y|Y for Yes, any other key for No) : N
... skipping.
 
Remove test database and access to it? (Press y|Y for Yes, any other key for No) : N
... skipping.
 
Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.
Reload privilege tables now? (Press y|Y for Yes, any other key for No) : N
... skipping.

All done!

####################################################

sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

####################################################

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
log-error       = /var/log/mysql/error.log
bind-address    = 0.0.0.0

####################################################

sudo mysql -u root -p

####################################################

CREATE USER IF NOT EXISTS 
  'root'@'%'
  IDENTIFIED BY '8wnK20R9Z$';
GRANT ALL PRIVILEGES
  ON *.*
  TO 'root'@'%'
  WITH GRANT OPTION;
exit

####################################################
  
sudo systemctl restart mysql
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
sudo ufw allow in on enp0s3 to any port 3306
sudo ufw status

sudo systemctl status mysql
```

Wyłącz maszynę, przejdź do ustawień

* Zakładka Sieć
  * Wybierz Karta 1
  * Wybierz przekierowanie portów
  * Dodaj nową regułę przekierowania portów
    * Nazwa: MySQL Server
    * Protokół: TCP
    * IP hosta: 127.0.0.1
    * Port hosta: 3307
    * IP gościa: -
    * Port gościa: 3306
  * Dodaj nową regułę przekierowania portów
    * Nazwa: SSH
    * Protokół: TCP
    * IP hosta: 127.0.0.1
    * Port hosta: 2224
    * IP gościa: -
    * Port gościa: 22

Włącz maszynę, Gotowe.

Połączenie z bazą danych (w DataGrip):
- Host: 127.0.0.1
- Port: 3307
- User: root
- Password: 8wnK20R9Z$

Połączenie z maszyną wirtualną (z systemu Windows) w terminalu:
ssh zygmunt@127.0.0.1 -p 2224

Dalsze instrukcje do wykonania znajdują się w pliku `README.md` w katalogu `/mysql-db`
