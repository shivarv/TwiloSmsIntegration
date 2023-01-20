/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AccountTrigger on Account (before update) {

    if(!AccountHandler.isTriggerEnabled()) {
        return;
    }

    if(Trigger.isUpdate && Trigger.isBefore) {
        AccountHandler.processAccountsUpdate((List<Account>) Trigger.new, 
                                (Map<Id, Account>) Trigger.oldMap, (Map<Id, Account>) Trigger.newMap);
    }
}