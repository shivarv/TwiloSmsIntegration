/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
global with sharing class SmsMockHttpGeneratorTest implements HttpCalloutMock{

    Integer statusCode =  201;
    global SmsMockHttpGeneratorTest() {
    }

    global SmsMockHttpGeneratorTest(Integer statusCode) {
        this.statusCode = statusCode;
    }
    global HTTPResponse respond(HTTPRequest req) {
        TwilloConfig__c twilloConfiguration = TwilloConfig__c.getOrgDefaults();

        // Optionally, only send a mock response for a specific endpoint
        // and method.
        String accountSid = twilloConfiguration?.accountSid__c; // you can put ACCOUNT SID from twilio account
        System.assertEquals('https://api.twilio.com/2010-04-01/Accounts/'+accountSid+'/SMS/Messages.json', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"errorMessage":"Sms Sent Failed"}');
        res.setStatusCode(statusCode);
        return res;
    }

   

}