set -o vi
export CDPATH=$HOME:$HOME/Dokumente/data:$HOME/homassistant
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/.local/bin:/home/harry/Dokumente/exp:$PATH
export EDITOR=nvim
export VISUAL=nvim
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
export FZF_DEFAULT_OPTS="
--height 40%
--layout=reverse
--border
--preview-window=right:60%
--bind=ctrl-u:preview-up,ctrl-d:preview-down
--color=bg+:#1e1e2e,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="
--preview 'bat --style=numbers --color=always {}'
"

source /etc/profile
alias ..="cd .."
alias restartgnome="killall -3 gnome-shell"
alias feh="feh -ZF"
alias fzfqv="fzf --preview 'bat --style=numbers --color=always {}' | xargs -n 1 nvim"
alias lspass='find "$HOME" -maxdepth 1 -type f -name ".pass_*" -printf "%f\n"'
alias lsdot='find "$HOME" -maxdepth 1 -type f -name ".*" -printf "%f\n"'
alias xc22='vncviewer 192.168.2.157'
alias xc650='vncviewer 192.168.2.188'
alias xspinner='vncviewer 192.168.2.192'
alias fpdeploy='cd /home/harry/Dokumente/rs && make deploy'
alias phono="pactl load-module module-loopback source=alsa_input.pci-0000_00_1f.3.analog-stereo"

# Listet alle definierten Aliase und Funktionen alphabetisch sortiert auf.
listdefs() {
      printf '=== Aliase ===\n'
      alias | LC_ALL=C sort

      printf '\n=== Funktionen ===\n'
      compgen -A function | LC_ALL=C sort
  }


# Öffnet eine vorhandene tmux-Sitzung oder erstellt eine neue.
attach() {
  if (( $# > 1 )); then
    printf 'Verwendung: attach [SESSION]\n' >&2
    return 2
  fi

  local session="$1"
  local -a sessions menu
  local i

  if [[ -z "$session" ]]; then
    mapfile -t sessions < <(tmux list-sessions -F '#S' 2>/dev/null)

    if (( ${#sessions[@]} == 0 )); then
      session="meinserver"
    else
      for i in "${!sessions[@]}"; do
        menu+=("${sessions[$i]}" "")
      done

      session=$(
        /usr/bin/dialog \
          --keep-tite \
          --stdout \
          --title "tmux" \
          --menu "Sitzung auswählen:" \
          20 70 12 \
          "${menu[@]}"
      ) || return
    fi
  fi

  tmux new-session -A -D -s "$session"
}

# Sucht am Anfang bereinigter Einträge im Bash-Verlauf nach einem Begriff.
hgrep()
{
    local suchbegriff="$1"

    history |
        sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//;
                s/[[:space:]]+/ /g;
                s/^ //;
                s/ $//' |
        awk -v begriff="$suchbegriff" '
            index($0, begriff) == 1 &&
            (length($0) == length(begriff) ||
             substr($0, length(begriff) + 1, 1) == " ")
        ' |
        sort -u
}

# Startet eine RDP-Verbindung und liest das Passwort aus ~/.pass_BENUTZER.
rdp() {
  local password_file="$HOME/.pass_$1"
  shift

  if [[ ! -r "$password_file" ]]; then
    printf 'Passwortdatei nicht lesbar: %s\n' "$password_file" >&2
    return 1
  fi

  xfreerdp3 \
    /w:3300 \
    /h:1300 \
    /kbd:layout:0x00000407 \
    "$@" \
    "/p:$(< "$password_file")"
}

alias x201="rdp hwolf /v:192.168.10.201 /u:hwolf /d:ul-dom"
alias x104="rdp hwolf /v:192.168.2.104 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias x109="rdp hwolf /v:192.168.2.109 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias x110="rdp hwolf /v:192.168.2.110 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xmarianne="rdp hwolf /v:192.168.2.163 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xkg="rdp kg /v:192.168.2.27 /u:kgroezinger /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias x2177="rdp hwolf /v:192.168.2.177 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias x2150="rdp hwolf /v:192.168.2.150 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xudo="rdp uweissflog /v:192.168.10.16 /u:uweissflog /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xtim="rdp timbuesch /v:192.168.10.12 /u:timbüsch /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xcadlaptop1="rdp hwolf /v:192.168.2.48 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xcadlaptop2="rdp hwolf /v:192.168.2.174 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xazubi="rdp ulmer /v:192.168.10.23 /u:azubi /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xazubi_ashwolf="rdp hwolf /v:192.168.10.23 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xmr="rdp mroessler /v:192.168.10.24 /u:mroessler /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xza="rdp zalbrecht /v:192.168.2.62 /u:zalbrecht /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xtb="rdp tb /v:192.168.10.17 /u:tbangerdt /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xdominik="rdp hwolf /v:192.168.2.168 /u:hwolf /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias xshopfloor="rdp ulmer /v:192.168.2.63 /u:shopfloor1 /d:ul-dom"
alias xmessmaschine="rdp ulmer /v:192.168.2.63 /u:messmaschine /d:ul-dom"
alias x154="rdp hwolf /v:192.168.2.154 /u:ulmer"
alias x2.87="rdp ulmer /v:192.168.2.87 /u:ulmer /cert:tofu /auth-pkg-list:none,ntlm"
alias x2.12="rdp ulmer /v:192.168.2.12 /u:ulmer /cert:tofu /auth-pkg-list:none,ntlm"
alias xveeam="rdp ulmer /v:192.168.2.87 /u:ulmer /cert:tofu /auth-pkg-list:none,ntlm"
alias xhome="rdp gnomerdp /v:192.168.2.97 /u:harry /cert:tofu /auth-pkg-list:none,ntlm"
alias xguul="rdp gulmer /v:192.168.2.53 /u:gulmer /d:ul-dom"
alias xam="rdp hwolf /v:192.168.2.90 /u:hwolf /d:ul-dom"
alias xlotta25="rdp treichert /v:192.168.2.27 /u:treichert /d:ul-dom"
alias xjherrmann="rdp jherrmann /v:TSP39800.ul-dom.ulmer-automation.de /u:treichert /d:ul-dom"
alias xwareneingang="rdp ulmer /v:LEV359678A.ul-dom.ulmer-automation.de /u:wareneingang /d:ul-dom /cert:tofu /auth-pkg-list:none,ntlm"
alias bsv="gvncviewer 192.168.178.70"
alias vpnon="nmcli connection up id Ulmer"
alias vpnoff="nmcli connection down id Ulmer"
alias rename=perl-rename
alias sshpi="ssh harry@192.168.178.55"
alias sshhome="ssh harry@192.168.178.52"
alias dockprune="docker system prune -a --volumes"
alias chksums="find . -type f -print0 | xargs -0 sha256sum > chksums.txt"
alias win10="qemu-system-x86_64 \
  -enable-kvm \
  -machine q35,accel=kvm \
  -cpu host \
  -smp 4 \
  -m 8G \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file=OVMF_VARS.4m.fd \
  -device ich9-ahci,id=sata \
  -drive file=windows10.qcow2,if=none,id=disk \
  -device ide-hd,drive=disk,bus=sata.0 \
  -device virtio-vga \
  -boot menu=on"
alias lsempty="find . -maxdepth 1 -type d -empty"
alias vim="nvim"
alias vi="nvim"
alias sda3="sudo mount /dev/sda3 /home/harry/sda3 && cd /home/harry/sda3/home/harry"
alias sdb1="sudo mount /dev/sdb1 /home/harry/sdb1 && cd /home/harry/sdb1/"
alias anrufliste="fb_tools preis2938@fritz.box anrufliste"
alias dlfticker="curl -s https://www.deutschlandfunk.de \
| hxnormalize -x \
| hxselect 'article.b-news-item' \
| hxnormalize -x \
| hxselect -c article \
| hxunent \
| tr '\n' ' ' \
| sed 's/  */ /g' \
| sed 's/>/>\n/g' \
| sed 's/<[^>]*>//g' \
| sed ':a;N;$!ba;s/\n\n/\n/g'"

alias func="declare -f"
alias arch-test="echo \"3xCtrl+AltGr+9\";sudo systemd-nspawn -D /var/lib/machines/test1"
alias arch-test-tmp="echo \"3xCtrl+AltGr+9\";sudo systemd-nspawn -D /var/lib/machines/test1 --ephemeral"
alias lastpdf='xdg-open "$(fd -e pdf -d 1 . -0 | xargs -0 stat --format "%Y %n" | sort -nr | cut -d" " -f2- | fzf)"'
alias mkentry='python3 /home/harry/Dokumente/info/Aktuell/Tagebuch/mkentry.py'
alias agenda='python3 /home/harry/Dokumente/info/Aktuell/Tagebuch/agenda.py'
alias clever-tanken='python3 /home/harry/Dokumente/info/Programmieren/Python/clever-tanken.py'

#alias fzfp="fzf --preview 'bat --style=numbers --color=always {}'"
#alias fzfvim="nvim $(fzf)"

# Wechselt in das Verzeichnis, das die angegebene ausführbare Datei enthält.
cdgo()
{
    local file
    file=$(type -P "$1")

    if [[ -z "$file" ]]; then
        echo "Nicht im PATH gefunden: $1"
        return 1
    fi

    cd "$(dirname "$file")" || return
}

# Wechselt in das Verzeichnis, das die angegebene ausführbare Datei enthält.
pushdgo()
{
    local file
    file=$(type -P "$1")

    if [[ -z "$file" ]]; then
        echo "Nicht im PATH gefunden: $1"
        return 1
    fi

    cd "$(dirname "$file")" || return
}

# Öffnet den ersten von whereis gefundenen Pfad in Neovim.
nvimgo()
{
    local file
    file=$(whereis "$1" | cut -d: -f2- | xargs -n1 | head -n1)

    if [[ -z "$file" ]]; then
        echo "Nicht gefunden: $1"
        return 1
    fi

    nvim "$file"
}

# Wählt einen Git-Commit mit fzf aus und zeigt ihn mit git show an.
fshow() {
  git log --oneline | fzf | awk '{print $1}' | xargs git show
}

# Wählt einen Prozess mit fzf aus und beendet ihn mit SIGKILL.
fkill() {
  ps -ef | fzf | awk '{print $2}' | xargs kill -9
}

# Durchsucht Dateien mit ripgrep und öffnet einen fzf-Treffer in Neovim.
frg() {
  rg --line-number --no-heading --color=always "$@" |
  fzf --ansi \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --delimiter ':' \
      --bind 'enter:become(nvim {1} +{2})'
}

# Prüft, ob die NetworkManager-Verbindung "Ulmer" aktiv ist.
vpn_active() {
    nmcli -t -f NAME,TYPE,STATE connection show --active 2>/dev/null |
        grep -q "Ulmer:.*:activated"
}

# Erzeugt den Bash-Prompt abhängig von Host, VPN-Status und letztem Exit-Code.
set_prompt() {
    local exit_status=$?
    local prefix
    local prompt_host
    local status_color

    case "${HOSTNAME%%.*}" in
        arch-home)
            prompt_host="178.52"
            ;;
        arch-ul)
            prompt_host="2.97"
            ;;
        *)
            prompt_host="\h"
            ;;
    esac

    if vpn_active; then
        prefix="\[\e[42m\e[30m\]VPN AKTIV\[\e[0m\] "
    else
        prefix=""
    fi

    if (( exit_status == 0 )); then
        status_color="\[\e[1;32m\]"
    else
        status_color="\[\e[1;31m\]"
    fi

    PS1="${prefix}\[\e[1;37m\]\u@\[\e[1;36m\]${prompt_host}\[\e[1;37m\]:\w ${status_color}\$ \[\e[0m\]"
}

PROMPT_COMMAND=set_prompt

# Durchsucht ~/.ALLFILES ohne Beachtung der Groß- und Kleinschreibung.
ff() {
  grep -i "$@" "$HOME/.ALLFILES"
}

# Wählt mit fd und fzf ein Unterverzeichnis aus und wechselt dorthin.
fcd() {
  cd "$(fd --type d | fzf)"
}

# Wechselt anhand eines festgelegten Kurzschlüssels in ein Zielverzeichnis.
qcd ()
{
    # Nimmt 1 Argument entgegen, das ein String-Schlüssel ist, und
    # führt für jeden Schlüssel eine andere "cd"-Operation aus.
    case "$1" in
        haraldwolf)
            cd /home/harry/Dokumente/data/01_Person/01_HaraldWolf
            ;;
        helenewolf)
            cd /home/harry/Dokumente/data/01_Person/06_HeleneWolf
            ;;
        erbe)
            cd /home/harry/Dokumente/data/64_IT/10_ErbeAufteilung/10_finance_viewer
            ;;
        *)
            # Das angegebene Argument gehörte nicht zu den unterstützten Schlüsseln.
            echo "qcd: unknown key '$1'"
            return 1
            ;;
    esac
    # Der aktuelle Verzeichnisname wird ausgegeben, damit man weiß, wo man ist.
    pwd
}
# Einrichten einer Tab-Ergänzung
complete -W "haraldwolf helenewolf erbe" qcd

# Führt deutsche OCR für die angegebenen PDF-Dateien direkt an Ort und Stelle aus.
ocrpdf() {
    for f in "$@"; do
        /usr/bin/ocrmypdf -l deu --skip-text --rotate-pages --optimize 3 "$f" "$f"
    done
}

#chrootsda3() {
#    local host_uid root="$HOME/sda3"
#    host_uid=$(id -u)
#
#    if mountpoint -q "$root"; then
#        echo "Unmounting..."
#
#        sudo umount "$root/run/user/$host_uid" 2>/dev/null
#        sudo umount "$root/tmp" 2>/dev/null
#        sudo umount "$root/run" 2>/dev/null
#        sudo umount "$root/sys" 2>/dev/null
#        sudo umount "$root/proc" 2>/dev/null
#        sudo umount "$root/dev" 2>/dev/null
#        sudo umount "$root/home" 2>/dev/null
#        sudo umount "$root" 2>/dev/null
#
#        return
#    fi
#
#    echo "Mounting and entering chroot..."
#
#    mkdir -p "$root"/{dev,proc,sys,run,tmp,home}
#    mkdir -p "$root/run/user/$host_uid"
#
#    sudo mount -o subvol=root /dev/sda3 "$root" || return
#    sudo mount -o subvol=home /dev/sda3 "$root/home" || return
#
#    for i in dev proc sys run tmp; do
#        sudo mount --bind "/$i" "$root/$i" || return
#    done
#
#    sudo mount --bind "/run/user/$host_uid" "$root/run/user/$host_uid" || return
#
#    sudo chroot "$root" su - harry -c '
#uid=$(id -u)
#export XDG_RUNTIME_DIR=/run/user/$uid
#export WAYLAND_DISPLAY=wayland-0
#export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus
#export DISPLAY=:0
#exec bash
#'
#}
