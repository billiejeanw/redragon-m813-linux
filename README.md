# Redragon Rind Pro (M813-RGB-PRO) no Linux 🖱️🐧

Suporte completo e configuração do software oficial do mouse **Redragon Rind Pro (M813-RGB-PRO)** no Linux via Wine, com comunicação direta de baixo nível (`hidraw`) com o hardware e a memória EEPROM do mouse.

---

## ⚡ O Problema no Linux (Por que o Wine comum falha?)

Por padrão de segurança, o driver de barramento do Wine (`winebus.sys`) **bloqueia e ignora qualquer mouse ou teclado físico** de ser exposto via acesso HID direto (`hidraw`) no Linux para evitar duplicidade de ponteiro.

Ao executar o software oficial da Redragon no Wine sem configuração especial, o subsistema retorna `nDevNum = 0` (zero dispositivos encontrados):
```
warn:hid:is_hidraw_enabled Ignoring unsupported 25A7:FA7C hidraw mouse/keyboard
warn:hid:bus_main_thread ignoring hidraw device 25a7:fa7c with usages 0001:0002
```
Com isso, o software abria em modo "fantasma", sem conseguir alterar DPI, LEDs ou botões no mouse real.

---

## 🛠️ A Solução (Causa Raiz Resolvida)

Através da engenharia reversa do `winebus.sys`, este projeto aplica as chaves de registro exatas do barramento do Wine para criar exceções para o hardware da Redragon/Compx (`VID 25A7` / `PIDs FA7B e FA7C`), permitindo que o executável oficial faça o handshake de baixo nível com o receptor 2.4GHz e com o cabo USB:

* `HKLM\System\CurrentControlSet\Services\WineBus\Devices\25a7` → `Hidraw = 1`
* `HKLM\System\CurrentControlSet\Services\WineBus\Devices\25a7/fa7c` → `Hidraw = 1`
* `HKLM\System\CurrentControlSet\Services\WineBus` → `DisableHidraw = 0`, `DisableInput = 1`, `EnableHidraw = 25A7:FA7C`

---

## ✨ Recursos e Melhorias Desbloqueadas

1. **Leitura e Gravação em Tempo Real**:
   - Nível de bateria lido diretamente via wireless.
   - Status de carregamento.
   - Ajustes gravados na memória EEPROM do mouse ao clicar em **Apply**.
2. **Interface Traduzida para Português (pt-BR)**:
   - Todas as abas, botões e avisos traduzidos em `text.xml` (o arquivo original em inglês está preservado em `text_en.xml`).
3. **Recursos Ocultos Liberados no `Cfg.ini`**:
   - **Motion Sync**: Sincronização de movimento do sensor Pixart PAW3395 desbloqueada na interface.
   - **Auto Sleep**: Ajuste de tempo de suspensão para economia de bateria desbloqueado.
   - **Abertura Direta**: Janela abre visível imediatamente (sem ficar escondida apenas na bandeja do sistema).
4. **Integração com o Desktop**:
   - Atalho de aplicativo (`.desktop`) e ícone oficial integrado ao menu do seu ambiente (KDE, GNOME, XFCE, etc.).

---

## 🚀 Como Instalar e Usar

### Pré-requisitos:
* **Wine** instalado no sistema (`wine` ou `wine-staging`).
* Mouse conectado via receptor **2.4GHz** ou **cabo USB**.

### Instalação em 1 comando:
```bash
git clone https://github.com/billiejeanw/redragon-m813-linux.git
cd redragon-m813-linux
./install.sh
```

O script irá:
1. Configurar as diretivas no registro do Wine.
2. Reiniciar o barramento do Wine (`wineserver -k`).
3. Instalar o ícone oficial em `~/.local/share/icons`.
4. Criar o atalho no menu de aplicativos (`~/.local/share/applications/redragon-m813.desktop`).

### Como Executar:
* Pelo menu do seu sistema: procure por **Redragon M813 RGB-PRO**.
* Ou diretamente pelo terminal:
```bash
./launch.sh
```

---

## 📁 Estrutura do Repositório

```
redragon-m813-linux/
├── README.md              # Documentação completa
├── LICENSE                # Licença MIT
├── install.sh             # Script de instalação e configuração do Wine
├── launch.sh              # Script de inicialização rápida
├── assets/
│   └── redragon-m813.png  # Ícone do aplicativo em alta resolução
└── app/
    ├── OemDrv.exe         # Executável oficial Redragon (sensor PAW3395)
    ├── InitSetup.dll      # Biblioteca de inicialização do driver
    ├── Cfg.ini            # Arquivo de configuração (recursos extras desbloqueados)
    ├── text.xml           # Textos da interface traduzidos para Português
    ├── text_en.xml        # Backup dos textos originais em Inglês
    ├── appico.ico         # Ícone original
    └── skins/             # Texturas e renderização do mouse
```

---

## 📄 Licença

Este repositório é distribuído sob a licença [MIT](LICENSE). Os binários e skins oficiais são de propriedade da Redragon / Areson / Compx.
