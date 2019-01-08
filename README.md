# Salesforce field set Sample in Apex
================================================

## Overview
 A sample of how to use field set in Salesforce trigger.
 
## Description
 When you use a hierarchy (parent/child relationship) within the same object and don't want to modify your source code, 
 you can use 'Schema.FieldSetMember' class.
 To use this sample, you have to create a field set named 'OppDefaultInfo' and a new custom relationship Named 'OrgOpportunity__c' within opportunity.
