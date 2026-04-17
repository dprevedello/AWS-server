# 🚀 AWS Server

Stack Docker completo per AWS con PHP, MariaDB, phpMyAdmin, FTP e HTTPS tramite Nginx.

## 📦 Servizi inclusi

| Servizio     | Immagine               | Porta        | Descrizione                        |
|--------------|------------------------|--------------|------------------------------------|
| MariaDB      | linuxserver/mariadb    | 3306         | Database MySQL                     |
| phpMyAdmin   | phpmyadmin             | (via Nginx)  | Interfaccia web per il database    |
| Webapp       | php:8.2-apache         | (via Nginx)  | Server Apache + PHP 8.2            |
| FTP          | fauria/vsftpd          | 21, 15000-15100 | Accesso FTP ai file del sito    |
| Nginx        | nginx:alpine           | 80, 443      | Reverse proxy con SSL              |

## 🗂️ Struttura del progetto

```
AWS-server/
├── docker-compose.yml
├── nginx.conf
├── setup.sh            ← script setup completo
├── generate-ssl.sh     ← genera certificati SSL
├── www/                ← file PHP del sito (accesso anche via FTP)
├── ssl/                ← cert.pem e key.pem
└── data/
    └── mysql/          ← dati persistenti del database
```

## ⚡ Avvio rapido

```bash
# Clona il repository
git clone https://github.com/dprevedello/AWS-server.git
cd AWS-server

# Rendi eseguibili gli script
chmod u+x setup.sh generate-ssl.sh

# Esegui il setup completo (sostituisci con il tuo dominio AWS)
./setup.sh "*.compute-1.amazonaws.com"
```

Lo script `setup.sh` si occupa automaticamente di:
1. Installare Docker se non presente
2. Creare le cartelle necessarie
3. Generare il certificato SSL self-signed
4. Creare una pagina PHP di esempio
5. Avviare tutti i container

## 🔐 Generare solo il certificato SSL

```bash
./generate-ssl.sh "*.compute-1.amazonaws.com"
```

I file verranno salvati in `./ssl/cert.pem` e `./ssl/key.pem`.

## 🌐 URLs

| Servizio    | URL                          |
|-------------|------------------------------|
| Sito web    | https://tuodominio/          |
| phpMyAdmin  | https://tuodominio/pma/      |

## 📂 Accesso FTP

| Campo    | Valore      |
|----------|-------------|
| Host     | IP del server |
| Porta    | 21          |
| Utente   | johnsmith   |
| Password | 123456      |
| Modalità | Passiva (PASV) |

I file caricati via FTP saranno immediatamente visibili sul sito web.

## 🗄️ Connessione PHP al database

```php
$host = 'mariadb';    // nome del servizio Docker
$db   = 'isisPonti';
$user = 'johnsmith';
$pass = '123456';

$pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
```

## 🐳 Comandi utili

```bash
# Avvia i container
docker compose up -d

# Ferma i container
docker compose down

# Vedi i log in tempo reale
docker compose logs -f

# Riavvia un singolo servizio
docker compose restart nginx

# Stato dei container
docker compose ps
```

## ⚠️ Note di sicurezza

> Le credenziali nel `docker-compose.yml` sono di esempio. Per un ambiente di produzione si consiglia di usare un file `.env` con variabili d'ambiente e di non committarlo su GitHub.

Esempio `.env`:
```env
MYSQL_ROOT_PASSWORD=password_sicura
MYSQL_PASSWORD=password_sicura
FTP_PASS=password_sicura
```
