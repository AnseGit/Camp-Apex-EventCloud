trigger EventTrigger on CAMPX__Event__c (before insert, before update) {

    if(Trigger.isBefore){
            EventTriggerHandler.updateEvent(Trigger.New,Trigger.oldMap, Trigger.IsInsert);
    }
}