/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class SentSmsControllerTest {
    private static String ADMIN_PROFILE_NAME = 'System Administrator';
    @TestSetup
    static void makeData()
    {

        TestDataUtilities.disableAccountTrigger();
        Constants.webCalloutAllowedCodeSwitch = false;
        User newUser = TestDataUtilities.createUser(ADMIN_PROFILE_NAME, true);
        System.runAs(newUser) {
            Account testAccount = new Account(name ='testAccount', Phone= '1112223334');
            insert testAccount;
        }
    }

    @isTest
    private static void sentSmsToCustomerTest() {
        List<User> newUser = [Select id FROM User where username like '%testabc%'];
        List<Account>  accountRecord = [Select Id, Phone FROM Account limit 1];
        Boolean isMessageHandlerSuccessful = true;
        System.runAs(newUser.get(0)) {
            try {
                SentSmsController.sentSmsToCustomer('hello test', accountRecord.get(0).Id);
            } catch(Exception e) {
                isMessageHandlerSuccessful = false;
            }
        }
        System.assert(isMessageHandlerSuccessful, 'Error happend on calling sentSmsToCustomer');
    }

    @isTest
    private static void sentSmsToCustomerWrongInputTest() {
        List<User> newUser = [Select id, MobilePhone FROM User where username like '%testabc%'];
        List<Account>  accountRecord = [Select Id, Phone FROM Account limit 1];
        Boolean smsEmptyErrorHappened = false;
        Boolean userRecordEmptyErrorHappened = false;
        Boolean accountRecordEmptyErrorHappened = false;

        System.runAs(newUser.get(0)) {
            try {
                SentSmsController.sentSmsToCustomer('', accountRecord.get(0).Id);
            } catch(Exception e) {
                smsEmptyErrorHappened = true;
            }
            try {
                SentSmsController.checkDataException(null, null, 'hello' );
            }  catch(Exception e) {
                userRecordEmptyErrorHappened = true;
            }
            try {
                SentSmsController.checkDataException(newUser, null, 'hello' );
            }  catch(Exception e) {
                accountRecordEmptyErrorHappened = true;
            }
        }
        System.assert(smsEmptyErrorHappened, 'SMS empty error didnt happen');
        System.assert(userRecordEmptyErrorHappened, 'USer record empty error didnt happen');
        System.assert(accountRecordEmptyErrorHappened, 'Account record empty error didnt happen');

    }

}