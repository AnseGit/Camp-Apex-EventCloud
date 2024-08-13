public with sharing class SponsorTriggerHandler {
    public SponsorTriggerHandler() {
    }

    public static void insertSponsor(List<CAMPX__Sponsor__c> sponsorList, Boolean isInsert){
        for(CAMPX__Sponsor__c sl : sponsorList){
            if(isInsert == true){
                if(sl.CAMPX__Email__c == null){
                    sl.CAMPX__Email__c.addError('A sponsor can not be created without an email address');
                }

                if(sl.CAMPX__Status__c == null){
                    sl.CAMPX__Status__c = 'Pending';     
                }
            }

            if(sl.CAMPX__ContributionAmount__c != null && sl.CAMPX__ContributionAmount__c != 0){
                sl.CAMPX__Tier__c = calkSponsorTier(sl);
            }      
            
            if(sl.CAMPX__Status__c == 'Accepted' && sl.CAMPX__Event__c == null){
                sl.CAMPX__Status__c.addError('A Sponsor must be associated with an event before being Accepted.');
            }
        } 
    }

    private static String calkSponsorTier(CAMPX__Sponsor__c sponsor){
        String tier = '';
        
        if(sponsor.CAMPX__ContributionAmount__c > 0 && sponsor.CAMPX__ContributionAmount__c < 1000){
            tier = 'Bronze';
        } else if(sponsor.CAMPX__ContributionAmount__c >= 1000 && sponsor.CAMPX__ContributionAmount__c < 5000){
            tier = 'Silver';
        } else if(sponsor.CAMPX__ContributionAmount__c >= 5000){
                tier = 'Gold';
        } else{
            tier = '';
        }    

        return tier;
    }
}
