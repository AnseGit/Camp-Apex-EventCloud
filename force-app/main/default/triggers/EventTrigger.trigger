trigger EventTrigger on CAMPX__Event__c (before insert, before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            EventTriggerHandler.insertEvent(Trigger.New);
        }

        if(Trigger.isUpdate){
            EventTriggerHandler.updateEvent(Trigger.new, trigger.oldMap);
        }
    }      
}