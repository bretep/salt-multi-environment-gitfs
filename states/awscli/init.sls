/opt/awscli/venv:
  virtualenv.managed:
    - system_site_packages: False
    - requirements: /opt/awscli/requirements.txt
    - require:
      - file: awscli_requirements

awscli_requirements:
  file.managed:
    - name: /opt/awscli/requirements.txt
    - source: salt://awscli/requirements.txt
    - template: jinja

