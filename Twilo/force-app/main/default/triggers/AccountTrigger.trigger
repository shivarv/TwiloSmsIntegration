/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AccountTrigger on Account (before update) {
            System.debug('in AccountTrigger' + AccountHandler.isTriggerEnabled());

    if(!AccountHandler.isTriggerEnabled()) {
        return;
    }

    if(Trigger.isUpdate && Trigger.isBefore) {
        System.debug('in AccountTrigger update');
        AccountHandler.processAccountsUpdate((List<Account>) Trigger.new, 
                                (Map<Id, Account>) Trigger.oldMap, (Map<Id, Account>) Trigger.newMap);
    }
}