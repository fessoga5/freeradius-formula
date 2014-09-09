#
# vim: sts=2 ts=2 sw=2 expandtab autoindent
{% from "freeradius/map.jinja" import freeradius with context %}


freeradius_pkg:
  pkg.installed:
    - pkgs:
      - freeradius
      - freeradius-utils
      - freeradius-mysql
      - libfreeradius-client2

freeradius:
  pkg:
    - installed
  service:
    - running
    - enable: True
    #- watch:
     # - file: /sr/local/etc/mpd5/mpd.conf
     
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
