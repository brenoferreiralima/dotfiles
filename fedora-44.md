
# Fedora 44 Custom After Install (Gnome Core System)  
*based on fedora everything iso with fedora custom operating system option*


## Summary 
1. Edit dnf.conf
2. Add Extra Confs
3. Add extra repos
4. Update system
5. Install packages
6. Tweaks


## 1. Edit dnf.conf
### /etc/dnf/dnf.conf
```sh
echo -e "[main]\ndefaultyes=True\nfastestmirror=True\ninstall_weak_deps=False\nmax_parallel_downloads=20\n" | sudo tee /etc/dnf/dnf.conf > /dev/null
```


## 2. Add Extra Confs
### NTSync Module
```sh
echo "ntsync" | sudo tee /etc/modules-load.d/ntsync.conf > /dev/null
```


## 3. Add Extra Repos
### Fedora 3rd Party
```sh
sudo dnf install fedora-workstation-repositories && sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 && sudo dnf config-manager setopt google-chrome.enabled=1
```

### RPM Fusion
```sh
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```
### RPM Fusion Tainted (needs RPM Fusion)
```sh
sudo dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
```

### Terra Release
```sh
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
```

### Visual Studio Code
```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
```


## 4. Update System
### Update
```sh
sudo dnf autoremove && sudo dnf clean all && sudo dnf distro-sync
```


## 5. Install Packages
### System Extras  
```sh
sudo dnf install bash-color-prompt usbutils pulseaudio-utils libglvnd-gles
```

### Tuned
```sh
sudo dnf install tuned tuned-ppd
```

### NetworkManager
```sh
sudo dnf install NetworkManager-bluetooth NetworkManager-wifi NetworkManager-wwan
```

### Pipewire
```sh
sudo dnf install pipewire pipewire-pulseaudio pipewire-utils
``` 

### ffmpeg
```sh
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
```

### Gstreamer
```sh
sudo dnf install gstreamer1-plugins-good gstreamer1-plugins-good-extras gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly-free gstreamer1-plugins-ugly gst-thumbnailers pipewire-gstreamer gstreamer1-plugin-\*
```

### Codecs
### Intel
```sh
sudo dnf install intel-media-driver
```

### AMD
```sh
sudo dnf install mesa-va-drivers-freeworld
```
```sh
sudo dnf install mesa-va-drivers-freeworld.i686
```

### NVIDIA
```sh
sudo dnf install libva-nvidia-driver
```
```sh
sudo dnf install libva-nvidia-driver.i686
```

### DVD
```sh
sudo dnf install libdvdcss
```

### Firmwares
```sh
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"
```

### Fonts  
```sh
sudo dnf install google-noto-\*
```

### Gnome Base Apps
```sh
sudo dnf install gdm gnome-control-center gnome-backgrounds ptyxis
```
```sh
sudo systemctl set-default graphical.target
```

### Gnome Core Apps  
```sh
sudo dnf install decibels gnome-calculator gnome-calendar snapshot gnome-characters gnome-clocks gnome-connections gnome-contacts baobab gnome-disk-utility simple-scan papers nautilus gnome-font-viewer loupe gnome-logs gnome-maps gnome-music gnome-system-monitor gnome-text-editor showtime gnome-weather epiphany
```

### Gnome Extras  
```sh
sudo dnf install dconf-editor file-roller glycin-thumbnailer papers-nautilus
```

### Extras
```sh
sudo dnf install aria2 btop code expect fastfetch firacode-nerd-fonts firamono-nerd-fonts fish fontawesome-fonts-all fzf gh google-chrome-stable plocate tar tldr vim wget yt-dlp
```

### Tweaks
### Reset Gnome Shell Apps Order
```sh
gsettings set org.gnome.desktop.app-folders folder-children []
```
```sh
gsettings set org.gnome.shell app-picker-layout []
```
### Set Volume Steps to 5
```sh
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-step 5
```

