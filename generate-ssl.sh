#!/bin/bash

# ============================================================
#  generate-ssl.sh
#  Genera un certificato SSL self-signed per il server AWS
# ============================================================

DOMAIN="${1:-*.compute-1.amazonaws.com}"
SSL_DIR="./ssl"
DAYS=365

echo "🔐 Generazione certificato SSL per: $DOMAIN"
echo "   Cartella output: $SSL_DIR"
echo "   Validità: $DAYS giorni"
echo ""

# Crea la cartella ssl se non esiste
mkdir -p "$SSL_DIR"

# Genera chiave privata e certificato self-signed
openssl req -x509 -nodes -days "$DAYS" -newkey rsa:2048 \
  -keyout "$SSL_DIR/key.pem" \
  -out "$SSL_DIR/cert.pem" \
  -subj "/CN=$DOMAIN"

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Certificato generato con successo!"
  echo "   → $SSL_DIR/cert.pem"
  echo "   → $SSL_DIR/key.pem"
  echo ""
  echo "ℹ️  Scadenza: $(openssl x509 -enddate -noout -in $SSL_DIR/cert.pem)"
else
  echo ""
  echo "❌ Errore durante la generazione del certificato."
  exit 1
fi
