/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class TestDataUtilities {
    private static Integer userRecordCount = 0;
    public static void configureClassificationSetting() {
        CustomClassification__c setting = new CustomClassification__c(SetupOwnerId=UserInfo.getOrganizationId());
        setting.bronzeCustomerValue__c = 10000;
        setting.silverCustomerValue__c = 25000;
        setting.goldCustomerValue__c = 50000;
        upsert setting;
    }

    public static void disableAccountTrigger() {
        TriggerConfig__c setting = new TriggerConfig__c(SetupOwnerId=UserInfo.getOrganizationId());
        setting.isAccountTriggerEnabled__c = false;
        upsert setting;
    }

    public static void enableAccountTrigger() {
        TriggerConfig__c setting = TriggerConfig__c.getOrgDefaults();
        setting.isAccountTriggerEnabled__c = true;
        upsert setting;
    }

    public static void enableTwiloConfigSetting() {
        TwilloConfig__c setting = new TwilloConfig__c(SetupOwnerId=UserInfo.getOrganizationId());
        setting.accountSid__c = 'ACd3b43ae5cf7fa7d058625026ea4c8df5';
        setting.token__c = 'ACd3b43ae5cf7fa7d058625026ea4';

        upsert setting;
    }

    //for package only standard profiles
    public static User createUser(String stdProfile, Boolean isInsert) {
        List<Profile> userProfile = [SELECT id, name FROM Profile WHERE Name =:stdProfile];
        String userName = 'testabc' + userRecordCount + '@xyz.com';
        String email = 'testabc' + userRecordCount + '@xyz.com';
        String alias = 'tsta'+userRecordCount;
        String lastName ='testLastName'+userRecordCount;
        String languageLocaleKey = 'en_US'; 
        String emailEncodingKey = 'UTF-8'; 
        String localeSidKey = 'en_US';
        String  timeZoneSidKey = 'America/Los_Angeles';
        String MobilePhone = String.valueOf(1234567890 +userRecordCount);
        Id profileId = userProfile.get(0)?.id;
        User newUser = new User(UserName = UserName, email = email, alias = alias, LastName = lastName,
                LanguageLocaleKey = languageLocaleKey, emailEncodingKey = emailEncodingKey,
                LocaleSidKey = LocaleSidKey, TimeZoneSidKey = timeZoneSidKey,
                ProfileId = ProfileId, MobilePhone = MobilePhone
            );
        if(isInsert) {
            insert newUser;
        }
        userRecordCount++;
        return newUser;
    }
}