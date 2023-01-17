/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@isTest
private class AccountHandlerTest {
    private static Integer oppCounter = 0;
    @TestSetup
    static void makeData()
    {
        configureClassificationSetting();
        disableAccountTrigger();
        Account testAccount = new Account(name ='testAccount');
        insert testAccount;
    }

    @isTest
    static void testAccountFormulaField(){
        Account testAccount = [select id, name, customer_Classification__c, customerSpendSummary__c FROM Account LIMIT 1 ];

        System.assertEquals(testAccount.customer_Classification__c, null, 'customer default classification is to be empty');
        Opportunity goldOpportunity = createOpportunity(System.Label.goldCustomerLabel, testAccount.Id);
        insert goldOpportunity;
        testAccount = [select id, name, customer_Classification__c, customerSpendSummary__c FROM Account where Id = :testAccount.Id LIMIT 1 ];
        System.assertEquals( System.Label.goldCustomerLabel, testAccount.customer_Classification__c, 'customer classification has to be Gold');
  
        emptyOpportunity(testAccount.Id);
        Opportunity silverOpportunity = createOpportunity(System.Label.silverCustomerLabel, testAccount.Id);
        insert silverOpportunity;
        testAccount = [select id, name, customer_Classification__c, customerSpendSummary__c FROM Account LIMIT 1 ];
        System.assertEquals(System.Label.silverCustomerLabel, testAccount.customer_Classification__c,  'customer classification has to be Silver');
        
        emptyOpportunity(testAccount.Id);
        Opportunity bronzeOpportunity = createOpportunity(System.Label.bronzeCustomerLabel, testAccount.Id);
        insert bronzeOpportunity;
        testAccount = [select id, name, customer_Classification__c, customerSpendSummary__c FROM Account LIMIT 1 ];
        System.assertEquals(System.Label.bronzeCustomerLabel, testAccount.customer_Classification__c,  'customer classification has to be Bronze');
	}

    @isTest
    static void testAccountGoldTierEvent() {
        enableAccountTrigger();
        Account testAccount = [select id, name, customer_Classification__c, customerSpendSummary__c FROM Account LIMIT 1 ];
        Opportunity bronzeOpportunity = createOpportunity(System.Label.bronzeCustomerLabel, testAccount.Id);
        insert bronzeOpportunity;
        Opportunity goldOpportunity = createOpportunity(System.Label.goldCustomerLabel, testAccount.Id);
        insert goldOpportunity;
        //email is sent mock service
    }

    @isTest
    static void filterGoldAccountsChange() {
        List<Account> changedGoldAccounts;
        Account testAccount = [select id, name, customer_Classification__c, customerSpendSummary__c FROM Account LIMIT 1 ];
        Opportunity bronzeOpportunity = createOpportunity(System.Label.bronzeCustomerLabel, testAccount.Id);
        insert bronzeOpportunity;
        testAccount = [select id, name, customer_Classification__c, customerSpendSummary__c FROM Account LIMIT 1 ];
        Map<Id, Account>  oldAccountMap = new Map<Id, Account>();
        oldAccountMap.put(testAccount.Id, testAccount);

        Opportunity goldOpportunity = createOpportunity(System.Label.goldCustomerLabel, testAccount.Id);
        insert goldOpportunity;
        testAccount = [select id, name, customer_Classification__c, customerSpendSummary__c FROM Account LIMIT 1 ];
        Map<Id, Account>  newAccountMap = new Map<Id, Account>();
        newAccountMap.put(testAccount.Id, testAccount);

        changedGoldAccounts = AccountHandler.filterGoldAccountsChange(oldAccountMap, newAccountMap);
        System.assertEquals(changedGoldAccounts.size(), 1, 'One of the account has been converted to gold');

    }
    private static void emptyOpportunity(Id accountId) {
        List<Opportunity> opportunities = [select id from Opportunity where AccountId = :accountId];
        if(!opportunities.isEmpty()) {
            delete opportunities;
        }
    }
    

    private static Opportunity createOpportunity(String type, Id accountId) {
        CustomClassification__c setting = CustomClassification__c.getOrgDefaults();
        Opportunity newOpportunity = new Opportunity(name = 'opp'+oppCounter, accountId = accountId, CloseDate = System.today(), StageName='Closed Won');
        oppCounter++;
        if(type == System.Label.goldCustomerLabel) {
            newOpportunity.amount = setting.goldCustomerValue__c;
        } else if(type == System.Label.silverCustomerLabel) {
            newOpportunity.amount = setting.silverCustomerValue__c;

        }
        else if(type == System.Label.bronzeCustomerLabel) {
            newOpportunity.amount = setting.bronzeCustomerValue__c;
        } else {
            newOpportunity.amount = setting.bronzeCustomerValue__c - 1;
        }
        return newOpportunity;
    }
 
    private static void configureClassificationSetting() {
        CustomClassification__c setting = new CustomClassification__c(SetupOwnerId=UserInfo.getOrganizationId());
        setting.bronzeCustomerValue__c = 10000;
        setting.silverCustomerValue__c = 25000;
        setting.goldCustomerValue__c = 50000;
        upsert setting;
    }

    private static void disableAccountTrigger() {
        TriggerConfig__c setting = new TriggerConfig__c(SetupOwnerId=UserInfo.getOrganizationId());
        setting.isAccountTriggerEnabled__c = false;
        upsert setting;
    }

    private static void enableAccountTrigger() {
        TriggerConfig__c setting = TriggerConfig__c.getOrgDefaults();
        setting.isAccountTriggerEnabled__c = true;
        upsert setting;
    }
}