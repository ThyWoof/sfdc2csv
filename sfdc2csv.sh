#!/bin/sh
#
# sfdc2csv - v1.0.1 - Paulo Monteiro - Summer/2015
#
# Mac OS 10.10.x / Ubuntu 14.x / CentOS 6.x compatible

usage() {
  
[ "$1" ] && echo 1>&2 "FATAL: $1" ; echo 1>&2 \
'
usage: sfdc2csv [OPTIONS]

OPTIONS:
    -s <URL>       Domain URL
    -r <REPORTID>  Report ID
    -t <TOKEN>     SFDC Token
    -u <USERNAME>  Username
    -p <PASSWORD>  Password
'
exit 1
}

# parse the command line

while [ "$#" -gt 0 ] ; do
  case "$1" in
    -s) [ "$2" ] && SFDC_DOMAIN="$2" || usage "$1: argument expected"
        shift 2;;
     
    -r) [ "$2" ] && SFDC_REPORT="$2" || usage "$1: argument expected"
        shift 2;;

    -t) [ "$2" ] && SFDC_TOKEN="$2" || usage "$1: argument expected"
        shift 2;;
          
    -u) [ "$2" ] && SFDC_USER="$2" || usage "$1: argument expected"
        shift 2;;
            
    -p) [ "$2" ] && SFDC_PASS="$2" || usage "$1: argument expected"
        shift 2;;

    -*) usage "$1: invalid option";;
    
     *) [ "$#" -eq 0 ] || usage 'too many arguments'
  esac
done

[ "$SFDC_DOMAIN" ] || usage "SFDC domain expected"
[ "$SFDC_REPORT" ] || usage "SFDC report expected"
[ "$SFDC_TOKEN"  ] || usage "SFDC token expected"
[ "$SFDC_USER"   ] || usage "SFDC username expected"
[ "$SFDC_PASS"   ] || usage "SFDC password expected"

# acquire a session

SFDC_SESSION=$(curl -s 'https://login.salesforce.com/services/Soap/u/34.0'\
  -H 'Content-Type: text/xml; charset=UTF-8'\
  -H 'SOAPAction: login' -d "\
<?xml version='1.0' encoding='utf-8' ?>
<env:Envelope 
  xmlns:xsd='http://www.w3.org/2001/XMLSchema' 
  xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' 
  xmlns:env='http://schemas.xmlsoap.org/soap/envelope/'>
  <env:Body>
    <n1:login xmlns:n1='urn:partner.soap.sforce.com'>
      <n1:username>$SFDC_USER</n1:username>
      <n1:password>$SFDC_PASS$SFDC_TOKEN</n1:password>
    </n1:login>
  </env:Body>
</env:Envelope>" |
sed -n 's:.*<sessionId>\(.*\)</sessionId>.*:\1:p')

[ "$SFDC_SESSION" = '' ] && usage 'unable to acquire the SFDC session'

# validade the report

curl -s "$SFDC_DOMAIN/$SFDC_REPORT" -b "sid=$SFDC_SESSION" -I -w '%{http_code}' | 
[ $(tail -1) = '404' ] && usage 'unable to render the SFDC report'

# export the report to CSV

curl -s "$SFDC_DOMAIN/$SFDC_REPORT?export=1&enc=UTF-8&xf=csv" -b "sid=$SFDC_SESSION"
