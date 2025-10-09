#!/usr/bin/env bash

# Verifica se o usuário passou um pacote
if [ -z "$1" ]; then
    echo "Uso: rtp <pkg>"
    exit 1
fi

PKG=$1

echo "==> Removendo $PKG com dnf"
sudo dnf remove "$PKG"

echo "==> Limpando dependências órfãs"
sudo dnf autoremove -y

echo "==> Limpando cache do dnf"
sudo dnf clean all

echo "==> Procurando por resíduos em ~"
RESIDUOS=$(find ~ -type d -iname "*$PKG*" 2>/dev/null)

if [ -n "$RESIDUOS" ]; then
    echo "Encontrados diretórios possivelmente relacionados a $PKG:"
    echo "$RESIDUOS"
    echo
    read -p "Deseja removê-los? (y/n) " resp
    if [ "$resp" = "y" ]; then
        echo "$RESIDUOS" | xargs rm -rf
        echo "Resíduos removidos"
    else
        echo "Resíduos mantidos"
    fi
else
    echo "Nenhum resíduo encontrado"
fi

echo "==> Finalizado: $PKG removido"
