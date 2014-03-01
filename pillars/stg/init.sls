{{ saltenv if saltenv != None else env}}:
  '*':
    - pillars.users
    - pillars.{{ saltenv if saltenv != None else env}}.pkgs
