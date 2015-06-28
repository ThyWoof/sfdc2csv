# sfdc2csv.sh

bash command line to export a SFDC report to CSV

## Introduction

Salesforce.com offers different ways to export data to flat files but it does introduce unnecessary complexity in the process.

This small bash code demonstrate how you can easily export SFDC reports to CSV by using the command line, and standard tools like curl, and sed.

## Workflow

1. curl to call the SFDC API login entrypoint
2. sed to parse the SOAP response
3. curl to validate the SFDC report endpoint
4. curl to export the report to CSV

## Parameters
```
-s <URL>   : SFDC domain URL
-r <UID>   : SFDC report unique ID
-t <TOKEN> : SFDC account token
-u <USER>  : SFDC user name
-p <PASS>  : SFDC password
```
## Example
```
./sfdc2csv.sh \
  -s https://test.salesforce.com \
  -r 00O80000005Ww9g \
  -u user@acme.com \
  -p my_password \
  -t get_your_token_from_the_account_setup_menu
```  
It is better to store both the password and token on a file to avoid display them as clear text when calling the script. For example:
```
./sfdc2csv.sh \
  -s https://test.salesforce.com \
  -r 00O80000005Ww9g \
  -u user@acme.com \
  -p $(cat password_file) \
  -t $(cat token_file)
```
