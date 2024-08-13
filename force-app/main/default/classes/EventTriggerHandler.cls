public with sharing class EventTriggerHandler{
    public EventTriggerHandler() {
    }

    public static void updateEvent(List<CAMPX__Event__c> newEvents, Map<Id, CAMPX__Event__c> eventListOld, Boolean isInsert){   
        for(CAMPX__Event__c ne : newEvents){
            if(isInsert){
                ne.CAMPX__Status__c = 'Planning';
                ne.CAMPX__StatusChangeDate__c = System.now();
                ne.CAMPX__NetRevenue__c = calkNetRevenue(ne.CAMPX__GrossRevenue__c, ne.CAMPX__TotalExpenses__c);
                continue;    
            }

            ne.CAMPX__NetRevenue__c = calkNetRevenue(ne.CAMPX__GrossRevenue__c, ne.CAMPX__TotalExpenses__c);

            CAMPX__Event__c oldEvent = eventListOld.get(ne.Id);
            if(oldEvent != null){
                if(ne.CAMPX__Status__c != oldEvent.CAMPX__Status__c){
                    ne.CAMPX__StatusChangeDate__c = System.now();
                }
            }
        }       
    }
    public static Decimal calkNetRevenue(Decimal grossRev, Decimal totalExp){
        Decimal netRev = 0;
        if(grossRev != null && totalExp != null){
            netRev = grossRev - totalExp;
        } else{
            netRev = null;
        }

        return netRev;
    }   
}