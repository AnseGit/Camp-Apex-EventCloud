public with sharing class EventTriggerHandler{
    public EventTriggerHandler() {
    }

    public static void insertEvent(List<CAMPX__Event__c> eventInsertList){   
        for(CAMPX__Event__c el : eventInsertList){
            el.CAMPX__Status__c = 'Planning';
            el.CAMPX__StatusChangeDate__c = System.now();          
        }     
    }

    public static void updateEvent(List<CAMPX__Event__c> updatedEvents, Map<Id, CAMPX__Event__c> oldEventMap){
        for(CAMPX__Event__c ue : updatedEvents){
            CAMPX__Event__c oldEvent = oldEventMap.get(ue.Id);
            if(ue.CAMPX__Status__c != oldEvent.CAMPX__Status__c){
                ue.CAMPX__StatusChangeDate__c = System.now();
            }
        }     
    }
}