trigger EventTrigger on CAMPX__Event__c (before insert) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            EventTriggerHandler.updateEvent(Trigger.New);
        }
    }
}