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
      
#save .desktop file in autostart folder
{% for application, setting in salt['pillar.get']('lxde:autostart', {}).iteritems() %}
xdg_autostart_{{ application }}:
  file.managed:
    - name: /etc/xdg/autostart/{{ application }}.desktop 
    - source: salt://lxde/files/autostart.desktop.jinja
    - template: jinja
    - defaults:
        application: "{{ application }}"
{%- endfor %}

#save .desktop file in startmenu
{% for application, setting in salt['pillar.get']('lxde:autostart', {}).iteritems() %}
lxde_startmenu_shortcut_{{ application }}:
  file.managed:
    - name: /usr/share/applications/{{ application }}.desktop 
    - source: salt://lxde/files/startmenu.desktop.jinja
    - template: jinja
    - defaults:
        application: "{{ application }}"
{%- endfor %}