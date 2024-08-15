public with sharing class SponsorTriggerHandler {
    public SponsorTriggerHandler() {
    }

    public static void insertSponsor(List<CAMPX__Sponsor__c> sponsorList, Map<Id, CAMPX__Sponsor__c> oldSponsorMap, Boolean isInsert){
        List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();
        Map<Id, CAMPX__Event__c> eventMap = getEventMap(sponsorList);

        for(CAMPX__Sponsor__c sponsor : sponsorList){
            if(isInsert){
               handleInsertLogic(sponsor);
            }

            if(sponsor.CAMPX__ContributionAmount__c != null && sponsor.CAMPX__ContributionAmount__c != 0){
                sponsor.CAMPX__Tier__c = calkSponsorTier(sponsor);
            }      
            
            if(sponsor.CAMPX__Status__c == 'Accepted'){
                handleAcceptedLogic(sponsor, oldSponsorMap, eventMap, eventsToUpdate);   
            }

            if(!isInsert){
                handleSubstractSponsorlogic(sponsor, eventMap, oldSponsorMap, eventsToUpdate);
                 
            }
        }

        if(!eventsToUpdate.isEmpty()){
            update eventsToUpdate;
        }
    }

    private static void handleInsertLogic(CAMPX__Sponsor__c sponsor){
        if(sponsor.CAMPX__Email__c == null){
            sponsor.CAMPX__Email__c.addError('A sponsor can not be created without an email address');
        }

        if(sponsor.CAMPX__Status__c == null){
            sponsor.CAMPX__Status__c = 'Pending';     
        }
    }

    private static String calkSponsorTier(CAMPX__Sponsor__c sponsor){ 
        if(sponsor.CAMPX__ContributionAmount__c > 0 && sponsor.CAMPX__ContributionAmount__c < 1000){
            return 'Bronze';
        } else if(sponsor.CAMPX__ContributionAmount__c >= 1000 && sponsor.CAMPX__ContributionAmount__c < 5000){
            return 'Silver';
        } else if(sponsor.CAMPX__ContributionAmount__c >= 5000){
            return 'Gold';
        } else{
            return '';
        }    
    }

    private static Map<Id,CAMPX__Event__c> getEventMap (List<CAMPX__Sponsor__c> sponsorList){
        Set<Id> eventIds = new Set<Id>();
        for(CAMPX__Sponsor__c sponsor : sponsorList){
            if(sponsor.CAMPX__Event__c != null){
                eventIds.add(sponsor.CAMPX__Event__c);
            }
        }

        return eventIds.isEmpty() ? new Map<Id, CAMPX__Event__c>() : 
                                    new Map<Id, CAMPX__Event__c>([SELECT Id, CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id IN :eventIds]);
    }

    private static void handleAcceptedLogic(CAMPX__Sponsor__c sponsor, Map<Id, CAMPX__Sponsor__c> oldSponsorMap, Map<Id, CAMPX__Event__c> eventMap, List<CAMPX__Event__c> eventsToUpdate){
        if(sponsor.CAMPX__Event__c == null){
            if(oldSponsorMap.get(sponsor.id).CAMPX__Event__c == null){
                sponsor.addError('A Sponsor must be associated with an event before being Accepted.');
                return;
            }    
        } 
        
        if(sponsor.CAMPX__ContributionAmount__c != null && sponsor.CAMPX__ContributionAmount__c != 0){
            CAMPX__Event__c relatedEvent = eventMap.get(sponsor.CAMPX__Event__c);
            if(relatedEvent != null){
                relatedEvent.CAMPX__GrossRevenue__c = (relatedEvent.CAMPX__GrossRevenue__c != null) ? relatedEvent.CAMPX__GrossRevenue__c + sponsor.CAMPX__ContributionAmount__c : sponsor.CAMPX__ContributionAmount__c;
                eventsToUpdate.add(relatedEvent);
            }
        }
    }

    private static void handleSubstractSponsorlogic(CAMPX__Sponsor__c sponsor, Map<Id, CAMPX__Event__c> eventMap, Map<Id, CAMPX__Sponsor__c> oldSponsorMap, List<CAMPX__Event__c> eventsToUpdate){
        CAMPX__Event__c relatedEvent = new CAMPX__Event__c(); 
        
        if(sponsor.CAMPX__Status__c != 'Accepted' && oldSponsorMap.get(sponsor.Id).CAMPX__Status__c == 'Accepted'){
            relatedEvent = eventMap.get(sponsor.CAMPX__Event__c);
        } else if(sponsor.CAMPX__Event__c != oldSponsorMap.get(sponsor.Id).CAMPX__Event__c && sponsor.CAMPX__Status__c == 'Accepted'){
            List<CAMPX__Event__c> eventList = [SELECT Id, CAMPX__GrossRevenue__c FROM CAMPX__Event__c WHERE Id = :oldSponsorMap.get(sponsor.id).CAMPX__Event__c LIMIT 1];
            relatedEvent = eventList[0];
        }    
           
        if(relatedEvent != null){
            relatedEvent.CAMPX__GrossRevenue__c = (relatedEvent.CAMPX__GrossRevenue__c != null) ? relatedEvent.CAMPX__GrossRevenue__c - sponsor.CAMPX__ContributionAmount__c : null;
            eventsToUpdate.add(relatedEvent);
        }                     
    }
}
