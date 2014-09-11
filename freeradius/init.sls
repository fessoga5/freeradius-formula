#
# vim: sts=2 ts=2 sw=2 expandtab autoindent
{% from "freeradius/map.jinja" import freeradius with context %}

#INSTALL FREERADIUS PACKAGES
freeradius_pkg:
  pkg.installed:
    - pkgs:
      - freeradius
      - freeradius-utils
      - freeradius-mysql
      - freeradius-postgresql
      - libfreeradius-client2

#SERVICE MGMT
freeradius:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - file: "{{ freeradius.path}}radiusd.conf" 
     
#CREATE CONFIG FILES
{%- if freeradius.create_files is defined %}
{%- for file in freeradius.get("create_files","") %}
"{{ freeradius.path }}{{ file.name }}":
  file.managed:
    - mode: 640
    - template: jinja
    - source: salt://freeradius/files/{{file.template}}
    - context:
        configname: {{file.name}}
{% endfor %}
{% endif %}

#SITES-ENABLED
{%- if freeradius.sites_enabled is defined %}
{%- for site in freeradius.get("sites_enabled","") %}
"{{ freeradius.path }}sites-enabled/{{site}}":
  file.symlink:
    - target: {{freeradius.path}}sites-available/{{ site }}
{%- endfor %}
{%- endif %}

#PRIVATE_FILE
{%- if freeradius.private_files is defined %}
{%- for file in freeradius.get("private_files","") %}
"{{ freeradius.path }}{{ file }}":
  file.managed:
    - mode: 640
    - source: salt://freeradius/private/{{ file }}
{% endfor %}
{% endif %}

