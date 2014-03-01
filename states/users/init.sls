{% set salt_env = pillar['master']['environment'] %}
# Add each user
{% for user, user_data in pillar['users'].iteritems() %}
user_{{ user }}:
  user.present:
    - name: {{ user }}
    - fullname: {{ salt['pillar.get']('users:' + user + ':fullname', 'No Name') }}
    - shell: {{ salt['pillar.get']('users:' + user + ':shell', '/bin/bash') }}
{% if 'groups' in pillar['users'][user] %}
    - optional_groups:
{% for group in salt['pillar.get']('users:' + user + ':groups', []) %}
      - {{ group }}
{% if group == salt_env %}
      - wheel
{% endif %}{% endfor %}
    - require:
      - group: sudouser
{% endif %}

# Enforce home directory
cp_user_home_{{ user }}:
  file.recurse:
    - name: /home/{{ user }}
    - user: {{ user }}
    - group: {{ user }}
{% if 'users/' + user in salt['cp.list_master_dirs'](salt_env) %}
    - source: salt://users/{{ user }}
{% else %}
    - source: salt://users/_default
{% endif %}
    - include_empty: True
    - require:
      - user: user_{{ user }}

# Check SSH key and add
{% if 'ssh_keys' in pillar['users'][user] %}
ssh_keys_{{ user }}:
  ssh_auth.present:
    - user: {{ user }}
    - names:
{% for ssh_key in salt['pillar.get']('users:' + user + ':ssh_keys', []) %}
      - {{ ssh_key }}{% endfor %}
    - require:
      - user: user_{{ user }}
      - file: cp_user_home_{{ user }}
{% endif %}{% endfor %}
