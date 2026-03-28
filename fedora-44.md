
# Fedora 44 Custom After Install (Gnome Core System)  

### Summary 
1. Edit dnf.conf
2. Update the system
3. Add the extra repos
4. Install the packages

### dnf.conf 
```sh
sudo nano /etc/dnf/dnf.conf
```
```sh
defaultyes=True
fastestmirror=True
install_weak_deps=False
max_parallel_downloads=20
```

### Update
```sh
sudo dnf distro-sync
```

### Fedora 3rd Party Repos
```sh
sudo dnf install fedora-workstation-repositories && sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 && sudo dnf config-manager setopt google-chrome.enabled=1
```

### RPM Fusion (Repo) 
```sh
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm  
```

### Terra Release (Repo)  
```sh
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release  
```

### Visual Studio Code
```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
```

### Packages
### VM (Virt-Manager / Gnome Boxes)
```sh
sudo dnf install spice-vdagent spice-webdavd
```

### System Extras  
```sh
sudo dnf install bash-color-prompt tuned tuned-ppd
```

### Gnome Base Apps  
```sh
sudo dnf install gdm gnome-control-center gnome-backgrounds gnome-console
```
```sh
sudo systemctl set-default graphical.target
```

### Gnome Core Apps  
```sh
sudo dnf install decibels gnome-calculator gnome-calendar snapshot gnome-characters gnome-clocks gnome-connections gnome-contacts baobab gnome-disk-utility simple-scan papers nautilus gnome-font-viewer loupe gnome-logs gnome-maps gnome-music gnome-system-monitor gnome-text-editor showtime gnome-weather epiphany
```

### Sound And Video 
```sh
sudo dnf install pipewire-alsa pipewire-gstreamer pipewire-pulseaudio pipewire-utils pipewire-v4l2
``` 
```sh
sudo dnf install gstreamer1-plugin-\* gstreamer1-plugins-good gstreamer1-plugins-good-extras gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly-free gstreamer1-plugins-ugly gst-thumbnailers
```

### Fonts  
```sh
sudo dnf install google-noto-\*
```

### Gnome Extras  
```sh
sudo dnf install glycin-thumbnailer papers-nautilus dconf-editor
```

### Everything  
```sh
sudo dnf install bash-color-prompt tuned tuned-ppd pipewire-alsa pipewire-gstreamer pipewire-pulseaudio pipewire-utils pipewire-v4l2 gstreamer1-plugin-\* gstreamer1-plugins-good gstreamer1-plugins-good-extras gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly-free gstreamer1-plugins-ugly gst-thumbnailers google-noto-\* gdm gnome-control-center gnome-backgrounds gnome-console decibels gnome-calculator gnome-calendar snapshot gnome-characters gnome-clocks gnome-connections gnome-contacts baobab gnome-disk-utility simple-scan papers nautilus gnome-font-viewer loupe gnome-logs gnome-maps gnome-music gnome-system-monitor gnome-text-editor showtime gnome-weather epiphany glycin-thumbnailer papers-nautilus dconf-editor
```
