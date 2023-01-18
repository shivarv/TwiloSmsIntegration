/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SentSmsController {
    
    @AuraEnabled
    public static void sentSmsToCustomer(String smsBody, Id accountId) {

        List<User> userRecord = [SELECT MobilePhone FROM User  WHERE Id = :UserInfo.getUserId()];
        List<Account> accountRecord = [SELECT Phone FROM Account where id = :accountId];
        String fromNumber;
        String toNumber;
        if(checkDataException(userRecord, accountRecord, smsBody)) {
    
            fromNumber = userRecord.get(0).MobilePhone;
            toNumber = accountRecord.get(0).Phone;
            if(!Constants.webCalloutAllowedCodeSwitch) {
                TwiloApiService.makeGetCallout(smsBody, fromNumber, toNumber);
            }
        }
    }

    @testVisible
    private static Boolean checkDataException(List<User> userRecord, List<Account>  accountRecord , String smsBody) {
        if(userRecord == null || userRecord.isEmpty() || String.isBlank(userRecord.get(0).MobilePhone)) {
            throw  new AuraHandledException('User Record Not Found or User didnt have mobilePhone Filled Exception');
        }
        if(accountRecord == null || accountRecord.isEmpty() || String.isBlank(accountRecord.get(0).Phone)) {
            throw  new AuraHandledException('Account Record Not Found or Account didnt have Phone Number Filled Exception');
        }
        if(String.isBlank(smsBody)) {
            throw  new AuraHandledException('Sms Content is Empty');
        }
        return true;
    }
}