# O que é o rtp?

Basicamente, tenho mania de quando remover/desinstalar um programa, apagar tudo referente a ele, pasta, arquivos, etc. Então, para diminuir esse “processo”, eu criei um script chamado rtp (remove this program). A ideia era só agilizar meu tempo e ter um retorno mais claro do que estou fazendo, além de, claro, estudar mais sobre scripts.

Aqui uma breve explicação que fiz para mim mesmo, durante sua criação:

## Explicando o rtp (remove this program)

### Verifica se o usuário passou um pacote

```bash
if [ -z "$1" ]; then
    echo "Uso: rtp <pkg>"
    exit 1
fi
```

**Traduzindo:**

```bash
SE [ a váriavel não existir ]; ENTÃO
    echo "Uso: rtp <pkg>"
    SAIR COM FALHA
FIM (FI)
```

### Definindo a váriavel

`PKG=$1`

### Etapas de funcionamento

```bash 
echo "==> Removendo $PKG com dnf"
sudo dnf remove "$PKG" # Removendo o pacote

echo "==> Limpando dependências órfãs"
sudo dnf autoremove -y # Limpando qualquer dependência do pacote ou órfão

echo "==> Limpando cache do dnf"
sudo dnf clean all # Limpando todo o cache do sistema
```

### Resíduos

```bash
echo "==> Procurando por resíduos em ~"
RESIDUOS=$(find ~ -type d -iname "*$PKG*" 2>/dev/null) # Procurando resíduos que o pacote tenha deixado dentro da pasta $HOME
```

**Traduzindo:**

```bash
RESIDUOS = PROCURAR EM $HOME {
    TIPO: apenas diretórios
    NOME: que contenha "*$PKG*" (maiúsculas/minúsculas ignoradas)
    ERROS: jogar fora (não mostrar)
}
```

```bash
if [ -n "$RESIDUOS" ]; then
    echo "Foram encontrados os seguintes diretórios possivelmente relacionados a $PKG:"
    echo "$RESIDUOS"
    echo
    read -p "Deseja removê-los? (y/n) " resp
    if [ "$resp" = "y" ]; then
        echo "$RESIDUOS" | xargs rm -rf
        echo "Resíduos removidos!"
    else
        echo "Resíduos mantidos."
    fi
else
    echo "Nenhum resíduo encontrado."
fi
```

**Traduzindo:**

```bash
SE [ variável RESIDUOS não está vazia ]; ENTÃO
    ESCREVER "Foram encontrados os seguintes diretórios possivelmente relacionados a $PKG:"
    ESCREVER "$RESIDUOS"
    ESCREVER linha vazia
    
    LER resposta do usuário: "Deseja removê-los? (y/n) "
    
    SE [ resposta == "y" ]; ENTÃO
        PEGAR cada linha de $RESIDUOS E EXECUTAR: rm -rf
        ESCREVER "Resíduos removidos!"
    SENÃO
        ESCREVER "Resíduos mantidos."
    FIM-SE
    
SENÃO
    ESCREVER "Nenhum resíduo encontrado."
FIM-SE
```

### Finalização

`echo "==> Finalizado: $PKG removido"`
