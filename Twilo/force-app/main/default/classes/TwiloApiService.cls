/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TwiloApiService {
    private static TwilloConfig__c twilloConfiguration = TwilloConfig__c.getOrgDefaults();

    @future(callout=true)
    public static void makeGetCallout(String smsBody, String fromPhNumber, String toPhoneNo) {
       HTTPResponse res = new HTTPResponse();
        try {
            String accountSid = twilloConfiguration?.accountSid__c; // you can put ACCOUNT SID from twilio account
            String token = twilloConfiguration?.token__c; // you can put AUTH TOKEN from twilio account
            String endPoint = 'https://api.twilio.com/2010-04-01/Accounts/'+accountSid+'/SMS/Messages.json';
            Blob creds = Blob.valueOf(accountSid+':' +token);
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            String VERSION  = '3.2.0';
            req.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(creds));
            req.setBody('To=' + EncodingUtil.urlEncode(toPhoneNo, 'UTF-8') + '&From=' + EncodingUtil.urlEncode(fromPhNumber,'UTF-8') + '&Body=' + smsBody);
            res = http.send(req);
      
            if(res.getStatusCode() != 201) {
                insert new Error_Log__c(Error_Log_Type__c='Api Error', 
                                        error_Details__c= 'SMS Failed to deliver'+ res.getStatus()+ ' '+res.getStatusCode());
            }
        } catch(Exception e) {
            insert new Error_Log__c(Error_Log_Type__c='Api Error', 
                                    error_Details__c= 'SMS Failed to deliver'+ res.getStatus()+ ' '+res.getStatusCode());
        }
     } 
}