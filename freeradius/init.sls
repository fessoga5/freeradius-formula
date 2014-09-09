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
     
"{{ freeradius.path }}sql.conf":
  file.managed:
    - mode: 640
    - source: salt://freeradius/files/sql.conf
    - template: jinja
