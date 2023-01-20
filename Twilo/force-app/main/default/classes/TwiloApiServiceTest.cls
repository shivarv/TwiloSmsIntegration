/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private with sharing class TwiloApiServiceTest {
   private static String accountSid = 'ACd3b43ae5cf7fa7d058625026ea4c8df5';

   @TestSetup
   static void makeData(){
        TestDataUtilities.enableTwiloConfigSetting();
   }

   @isTest
   static void testCallout() {
        // Set mock callout class 
        
        Test.setMock(HttpCalloutMock.class, new SmsMockHttpGeneratorTest());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
            TwiloApiService.makeGetCallout('hi test sms', '+22572993323', '+2335899220');
        Test.stopTest();
        
        List<Error_Log__c> errorLogs = [SELECT id, error_Details__c, Error_Log_Type__c FROM Error_Log__c];
        System.assert( errorLogs.isEmpty(), 'Errors Found in debug Log');
    }
    
   @isTest
   static void testNegativeCallout() {
        // Set mock callout class 
        
        Test.setMock(HttpCalloutMock.class, new SmsMockHttpGeneratorTest(200));
        Boolean isSmsSentSuccess = true;
        String errorMessage;
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
            TwiloApiService.makeGetCallout('hi test sms', '+22572993323', '+2335899220');
        
        Test.stopTest();
        List<Error_Log__c> errorLogs = [SELECT id, error_Details__c, Error_Log_Type__c FROM Error_Log__c];
        System.assertEquals(1, errorLogs.size(), 'Didnt find any error logs');

    }
}