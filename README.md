# Dotfiles

Persönliche Konfigurationen für Bash, Zsh, Git und Neovim. Das Repository verwendet
[GNU Stow](https://www.gnu.org/software/stow/), um die Dateien als symbolische
Links im Home-Verzeichnis bereitzustellen. `bootstrap.sh` installiert die
benötigten Pakete und richtet die Links ein.

## Unterstützte Systeme

Das Bootstrap-Skript erkennt den ersten verfügbaren Paketmanager:

| Paketmanager | Typisches System | Paketliste |
| --- | --- | --- |
| `apt-get` | Debian, Ubuntu | `packages/apt` |
| `dnf` | Fedora | `packages/dnf` |
| `pacman` | Arch Linux | `packages/pacman` |
| `brew` | macOS, Linuxbrew | `packages/brew` |

Erforderlich sind Bash und – außer bei Homebrew – ein Benutzer mit
`sudo`-Berechtigung.

## Installation

Repository klonen und Bootstrap-Skript ausführen:

```bash
git clone https://github.com/hawiwo/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash ./bootstrap.sh
```

Das Skript führt folgende Schritte aus:

1. Pakete aus der zum System passenden Paketliste installieren.
2. `~/.ssh` mit sicheren Verzeichnisrechten anlegen.
3. Optional vorhandene `id_ed25519`-Dateien installieren.
4. Die GitHub-SSH-Authentifizierung unverbindlich prüfen.
5. `bash`, `git`, `neovim` und `zsh` mit Stow in `$HOME` verlinken.

Bestehende Dateien wie `~/.bashrc` können einen Stow-Konflikt verursachen.
Sie sollten vor der Installation gesichert oder in das Repository übernommen
werden.

## FAQ

### Warum bricht Stow wegen einer vorhandenen Neovim-Konfiguration ab?

Wenn `~/.config/nvim/init.lua` bereits als normale Datei vorhanden ist,
überschreibt Stow sie nicht. Die bestehende Konfiguration sollte zuerst
gesichert und Stow danach erneut ausgeführt werden:

```bash
mkdir -p "$HOME/.config/nvim-backup"
mv "$HOME/.config/nvim/init.lua" "$HOME/.config/nvim-backup/init.lua"

cd "$HOME/dotfiles"
stow --dir="$PWD" --target="$HOME" bash git neovim zsh
```

Anschließend können die alte und die neue Konfiguration verglichen werden:

```bash
diff "$HOME/.config/nvim-backup/init.lua" \
    "$HOME/dotfiles/neovim/.config/nvim/init.lua"
```

Das Bootstrap-Skript sollte nicht mit `sudo` gestartet werden, da es für die
Paketinstallation selbst `sudo` verwendet. Der Hinweis, dass die
GitHub-SSH-Authentifizierung nicht eingerichtet ist, verursacht den
Stow-Abbruch nicht und kann bei einem über HTTPS geklonten Repository ignoriert
werden.

`stow --adopt` kann bestehende Dateien alternativ in das Repository übernehmen,
dabei aber die dort gespeicherte Konfiguration verändern. Das vorherige Sichern
ist daher die sicherere Vorgehensweise.

## Manuelle Einrichtung mit Stow

Einzelne Konfigurationen lassen sich unabhängig installieren:

```bash
stow --dir="$HOME/dotfiles" --target="$HOME" bash
stow --dir="$HOME/dotfiles" --target="$HOME" git
stow --dir="$HOME/dotfiles" --target="$HOME" neovim
stow --dir="$HOME/dotfiles" --target="$HOME" zsh
```

Links eines Pakets können entsprechend entfernt werden:

```bash
stow --delete --dir="$HOME/dotfiles" --target="$HOME" bash
```

## RDP-Passwörter

Die RDP-Aliase in `bash/.bashrc` enthalten keine Passwörter. Die Funktion
`rdp` liest sie beim Verbindungsaufbau aus Dateien außerhalb des Repositorys.

| Datei | Verwendete Aliase beziehungsweise Konten |
| --- | --- |
| `~/.pass_hwolf` | `hwolf` sowie `x154` |
| `~/.pass_kg` | `xkg` |
| `~/.pass_ulmer` | `xazubi`, `xshopfloor`, `xmessmaschine`, `x2.87`, `x2.12`, `xveeam` |
| `~/.pass_guul` | `xguul` |
| `~/.pass_lotta25` | `xlotta25` |

Eine Passwortdatei lässt sich ohne Klartext in der Shell-Historie anlegen:

```bash
read -rs -p "Passwort: " password
printf '\n'
printf '%s' "$password" > "$HOME/.pass_hwolf"
unset password
chmod 600 "$HOME/.pass_hwolf"
```

Für die anderen Kürzel wird der Dateiname entsprechend geändert. Nach einer
Änderung an `.bashrc` muss die Konfiguration neu geladen werden:

```bash
source ~/.bashrc
```

Fehlt eine Passwortdatei oder ist sie nicht lesbar, bricht `rdp` mit einer
Fehlermeldung ab.

## Paketlisten pflegen

Jede Datei unter `packages/` enthält einen Paketnamen pro Zeile. Neue Pakete
müssen unter dem Namen eingetragen werden, den der jeweilige Paketmanager
verwendet.

Beispiel:

```text
git
stow
neovim
```

Das Pacman-Setup verwendet `pacman -Syu`, um eine nicht unterstützte partielle
Arch-Linux-Aktualisierung zu vermeiden.

## Verzeichnisstruktur

```text
.
├── bash/.bashrc       Bash-Konfiguration, Aliase und Hilfsfunktionen
├── git/.gitconfig     Git-Konfiguration
├── neovim/.config/    Neovim-Konfiguration und Plugin-Lockfile
├── zsh/.zshrc         Zsh-Konfiguration
├── packages/          Paketlisten je Paketmanager
└── bootstrap.sh       Installation und Stow-Einrichtung
```

Die Verzeichnisse `bash`, `git`, `neovim` und `zsh` sind Stow-Pakete. Ihre interne
Struktur entspricht der späteren Struktur in `$HOME`.

## Prüfung vor einem Commit

Die Shell-Syntax und typische Patch-Fehler lassen sich ohne Änderungen am
System prüfen:

```bash
bash -n bootstrap.sh
bash -n bash/.bashrc
git diff --check
stow --simulate --dir="$PWD" --target="$HOME" bash git neovim zsh
```

## Sicherheit

- Passwörter, private SSH-Schlüssel und andere Geheimnisse gehören nicht in
  dieses Repository.
- Passwortdateien sollten ausschließlich für den Benutzer lesbar sein
  (`chmod 600 ~/.pass_*`).
- Optional vom Bootstrap-Skript erkannte SSH-Schlüssel sind nur für lokale,
  nicht versionierte Kopien gedacht.
- Falls ein Geheimnis bereits committed wurde, reicht das Löschen aus der
  aktuellen Datei nicht aus: Das Geheimnis muss geändert und gegebenenfalls
  aus der Git-Historie entfernt werden.
