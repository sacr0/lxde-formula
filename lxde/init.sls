{% from "lxde/map.jinja" import lxde with context %}
lxde_packages:
  pkg.installed:
    - pkgs:
      {%- for pkg in lxde.pkgs %}
      - {{ pkg }}
      {%- endfor %}

lxdm:
  service.running:
    - enable: True
    - require:
      - pkg: lxde_packages
    - watch:
      - file: {{ lxde.lxdm_conf }}

lxdm_config:
  file.managed:
    - name: {{ lxde.lxdm_conf }}
    - source: {{ lxde.lxdm_conf_src }}
    - template: jinja
    - require:
      - pkg: lxde_packages