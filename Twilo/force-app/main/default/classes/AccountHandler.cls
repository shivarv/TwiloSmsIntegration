/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class AccountHandler {

    private static CustomClassification__c customerclassification = CustomClassification__c.getOrgDefaults();



    public static void processAccountsUpdate(List<Account> accountsList, 
                                    Map<Id, Account> accountOldMap, Map<Id, Account> accountNewMap) 
    {
        List<Account> changedGoldAccounts = filterGoldAccountsChange(accountOldMap, accountNewMap );
    }

    public static List<Account> filterGoldAccountsChange( Map<Id, Account> accountOldMap, Map<Id, Account> accountNewMap)
    {
        List<Account> changedGoldAccounts = new List<Account>();
        for (Id accountId : accountOldMap.keySet()) {
            if(isAccountSpendSummaryGotGold(accountOldMap.get(accountId), accountNewMap.get(accountId))) {
                changedGoldAccounts.add(new Account(Id = accountId));
            }
        }
        return changedGoldAccounts;
    }

    private static boolean isAccountSpendSummaryGotGold(Account oldAccount, Account newAccount) {
        if(oldAccount?.customerSpendSummary__c != newAccount?.customerSpendSummary__c
                 && newAccount?.customerSpendSummary__c >= customerclassification?.goldCustomerValue__c) {
            return true;
        }
        return false;
    }

}