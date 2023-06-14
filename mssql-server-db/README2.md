
# Baza danych Microsoft SQL Server - VM VirtualBox

## Przydzielone zasoby sprzętowe

| Nazwa zasobu            | Przydział                                                                                                                     |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| Liczba rdzeni procesora | 2                                                                                                                             |
| Dysk                    | Kontroler SATA (ang. Serial ATA), typ VDI (ang. Virtual Disk Image), pojemność 30 GB, dynamiczny sposób przydzielania pamięci |
| Pamięć RAM              | 4 GB (4096 MB)                                                                                                                |

## Implementacja

Oprogramowanie wykorzystane do utworzenia instancji maszyny wirtualnej 
- Oracle VM VirtualBox w wersji 7.0.6. 

| Typ                | Nazwa                  | Wersja                     |
|--------------------|------------------------|----------------------------|
| System operacyjny  | Ubuntu                 | 20.04.5 LTS (Focal Fossa)  |
| Serwer bazy danych | Microsoft SQL Server   | 2022                       |

### Utworzenie maszyny wirtualnej - ustawienia:

1. Zakładka Name and Operating System
* Nazwa: MicrosoftSQLServer_VM
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

Pierwsze uruchomienie - konfiguracja:
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
  * Nazwa serwera: mssql-vm
  * Nazwa użytkownika: zygmunt
  * Hasło: root
* Ustawienia SSH: 
  * Zainstaluj serwer SSH: Zaznaczone
  * Importuj tożsamość SSH: Nie
* Polecane snapy serwerowe: domyślnie

### Instalacja serwera Microsoft SQL Server:

Instalacja bibliotek

```
sudo apt update && sudo apt upgrade -y
sudo apt install ufw
sudo apt install net-tools

# wygenerowanie kluczy ssh
ssh-keygen

sudo ufw enable
sudo ufw allow ssh

sudo service sshd status
sudo ufw status
```

Microsoft SQL Server - instalacja + konfiguracja

```
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2022.list)"

sudo apt update && sudo apt upgrade -y

sudo apt install mssql-server

sudo /opt/mssql/bin/mssql-conf setup

####################################################

SQL Server Edition: 2) Developer
Accept the license terms: Yes
Choose the language for SQL Server: 1) English
SA password: wvn4enbz9P

####################################################

systemctl status mssql-server

sudo apt update && sudo apt upgrade -y

sudo apt install curl

curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

sudo apt update && sudo apt upgrade -y

sudo apt install mssql-tools unixodbc-dev

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

sudo systemctl restart mssql-server
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
sudo ufw allow in on enp0s3 to any port 1433
sudo ufw status

sudo systemctl status mssql-server
```

Wyłącz maszynę, przejdź do ustawień

* Zakładka Sieć
  * Wybierz Karta 1
  * Wybierz przekierowanie portów
  * Dodaj nową regułę przekierowania portów
    * Nazwa: Microsoft SQL Server
    * Protokół: TCP
    * IP hosta: 127.0.0.1
    * Port hosta: 1434
    * IP gościa: -
    * Port gościa: 1433
  * Dodaj nową regułę przekierowania portów
    * Nazwa: SSH
    * Protokół: TCP
    * IP hosta: 127.0.0.1
    * Port hosta: 2226
    * IP gościa: -
    * Port gościa: 22

Włącz maszynę, Gotowe.

Połączenie z bazą danych (w DataGrip):
- Host: 127.0.0.1
- Port: 1434
- User: sa
- Password: wvn4enbz9P

Połączenie z maszyną wirtualną (z systemu Windows) w terminalu:
ssh zygmunt@127.0.0.1 -p 2226

Dalsze instrukcje do wykonania znajdują się w pliku `README.md` w katalogu `/mssql-server-db`
