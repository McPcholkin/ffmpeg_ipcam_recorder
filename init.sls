# Simple formula to install audio capture for motion

ip_camcorder_pkgs:
  pkg.installed:
    - pkgs:
      - ffmpeg
      - alsa-utils

add_user_to_audio:
  user.present:
    - name: motion
    - groups: 
      - video
      - audio

install_ipcam_start:
  file.managed:
    - name: /etc/motion/scripts/start_record.sh
    - source: salt://{{ slspath }}/start_record.sh
    - makedirs: True
    - user: motion
    - group: motion
    - mode: 775


install_ipcam_end:
  file.managed:
    - name: /etc/motion/scripts/end_record.sh
    - source: salt://{{ slspath }}/end_record.sh
    - makedirs: True
    - user: motion
    - group: motion
    - mode: 775


install_sound_start:
  file.managed:
    - name: /etc/motion/scripts/start_sound_only.sh
    - source: salt://{{ slspath }}/start_sound_only.sh
    - makedirs: True
    - user: motion
    - group: motion
    - mode: 775

install_sound_end:
  file.managed:
    - name: /etc/motion/scripts/end_sound_only_record.sh
    - source: salt://{{ slspath }}/end_sound_only_record.sh
    - makedirs: True
    - user: motion
    - group: motion
    - mode: 775
