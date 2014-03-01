sudo:
  pkg.installed

sudouser:
  group.present:
    - system: True

/etc/sudoers.d/sudouser:
  file.managed:
    - user: root
    - group: root
    - mode: 440
    - source: salt://sudo/sudouser
