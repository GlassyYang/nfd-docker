sleep 2
if [ -f /usr/local/etc/ndn/nfd-init.sh ]; then
  sleep 2 # post-start is executed just after nfd process starts, but there is no guarantee
  # that all initialization has been finished
  . /usr/local/etc/ndn/nfd-init.sh
fi

if [ -f /usr/local/etc/ndn/autoconfig.conf ]; then
  sleep 2 # post-start is executed just after nfd process starts, but there is no guarantee
  /usr/local/bin/ndn-autoconfig -d -c "/usr/local/etc/ndn/autoconfig.conf" &
fi