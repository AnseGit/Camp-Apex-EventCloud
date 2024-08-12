public with sharing class EventTriggerHandler{
    public EventTriggerHandler() {
    }

    public static void updateEvent(List<CAMPX__Event__c> eventList){   
        for(CAMPX__Event__c el : eventList){
            el.CAMPX__Status__c = 'Planning';
        }     
    }
}