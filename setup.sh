#!/bin/bash

# ============================================================
#  setup.sh
#  Script di setup completo per AWS Server
#  Crea le cartelle, genera i certificati SSL e avvia Docker
# ============================================================

DOMAIN="${1:-*.compute-1.amazonaws.com}"

echo "🚀 AWS Server - Setup iniziale"
echo "================================"
echo ""

# 1. Controlla che Docker sia installato
if ! command -v docker &> /dev/null; then
  echo "⚠️  Docker non trovato. Installazione in corso..."
  sudo apt update &> /dev/null && sudo apt upgrade -y &> /dev/null && sudo apt install -y docker.io
  sudo systemctl enable docker
  sudo systemctl start docker
  echo "✅ Docker installato."
else
  echo "✅ Docker trovato: $(docker --version)"
fi

# Controlla che docker compose sia disponibile
if ! docker-compose --version &> /dev/null; then
  echo "⚠️  Docker Compose plugin non trovato. Installazione in corso..."
  sudo apt install -y docker-compose
fi

echo ""

# 2. Crea struttura cartelle
echo "📁 Creazione struttura cartelle..."
mkdir -p ./www
mkdir -p ./ssl
mkdir -p ./data/mysql
echo "✅ Cartelle create:"
echo "   → ./www        (file PHP del sito)"
echo "   → ./ssl        (certificati SSL)"
echo "   → ./data/mysql (dati del database)"
echo ""

# 3. Genera certificato SSL
echo "🔐 Generazione certificato SSL..."
bash ./generate-ssl.sh "$DOMAIN"
echo ""

# 4. Crea una pagina PHP di esempio se www è vuota
if [ ! -f "./www/index.php" ]; then
  echo "📄 Creazione pagina PHP di esempio..."
  cat > ./www/index.php <<'EOF'
<?php
$host = 'mariadb';
$db   = 'isisPonti';
$user = 'johnsmith';
$pass = '123456';

echo "<h1>🚀 Server AWS attivo!</h1>";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    echo "<p style='color:green'>✅ Connessione al database riuscita!</p>";
} catch (PDOException $e) {
    echo "<p style='color:red'>❌ Errore DB: " . $e->getMessage() . "</p>";
}
?>
EOF
  echo "✅ Pagina di esempio creata in ./www/index.php"
  echo ""
fi

# 5. Avvia i container
echo "🐳 Avvio dei container Docker..."
sudo docker-compose up -d

if [ $? -eq 0 ]; then
  echo ""
  echo "================================"
  echo "✅ Setup completato con successo!"
  echo "================================"
  echo ""
  echo " 🌐  Sito web:    https://$DOMAIN/"
  echo " 🛠️  phpMyAdmin:  https://$DOMAIN/pma/"
  echo " 🗄️  MariaDB:     localhost:3306"
  echo " 📂  FTP:         ftp://$DOMAIN (porta 21)"
  echo ""
  echo "Per vedere i log:     docker compose logs -f"
  echo "Per fermare tutto:    docker compose down"
else
  echo ""
  echo "❌ Errore durante l'avvio dei container."
  exit 1
fi

# Aggiunge il tuo utente al gruppo docker
sudo usermod -aG docker $USER

# Applica il gruppo senza dover fare logout/login
newgrp docker

