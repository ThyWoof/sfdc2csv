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
