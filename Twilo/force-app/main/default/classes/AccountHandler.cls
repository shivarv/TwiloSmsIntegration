/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class AccountHandler {

    private static CustomClassification__c customerclassification = CustomClassification__c.getOrgDefaults();
    private static TwilloConfig__c twilloConfiguration = TwilloConfig__c.getOrgDefaults();

    private static String FROM_NUMBER_HARDCODE = twilloConfiguration?.ceoNumber__c;
    private static String TO_NUMBER_HARDCODE = '+447415423477';

    public static boolean isTriggerEnabled() {
        return TriggerConfig__c.getOrgDefaults().isAccountTriggerEnabled__c;
    }

    public static void processAccountsUpdate(List<Account> accountsList, 
                                    Map<Id, Account> accountOldMap, Map<Id, Account> accountNewMap) 
    {
        List<Account> changedGoldAccounts = filterGoldAccountsChange(accountOldMap, accountNewMap );
        for(Account changedGoldAccount : changedGoldAccounts) {
            String smsBody = String.format(Label.goldCustomerNotification, new List<String>{changedGoldAccount.Name});
            try{
                if(Constants.webCalloutAllowedCodeSwitch) {
                	TwiloApiService.makeGetCallout(smsBody, FROM_NUMBER_HARDCODE, TO_NUMBER_HARDCODE);
                }
            } catch(Exception e) {
                insert new Error_Log__c(Error_Log_Type__c='Apex Error', 
                                        error_Details__c= e.getMessage() + ' '+e.getStackTraceString()
                                    );
            }
        }

    }

    public static List<Account> filterGoldAccountsChange( Map<Id, Account> accountOldMap, Map<Id, Account> accountNewMap)
    {
        List<Account> changedGoldAccounts = new List<Account>();
        for (Id accountId : accountOldMap.keySet()) {
            if(isAccountSpendSummaryGotGold(accountOldMap.get(accountId), accountNewMap.get(accountId))) {
                changedGoldAccounts.add(new Account(Id = accountId, Name = accountNewMap.get(accountId).Name));
            }
        }
        return changedGoldAccounts;
    }

    private static boolean isAccountSpendSummaryGotGold(Account oldAccount, Account newAccount) {
        if(oldAccount.customer_Classification__c != newAccount.customer_Classification__c && 
        newAccount.customer_Classification__c == 'Gold') {
            return true;
        }
        return false;

    }

}