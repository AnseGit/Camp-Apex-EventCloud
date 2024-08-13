trigger SponsorTrigger on CAMPX__Sponsor__c (before insert, before update) {

    if(Trigger.isBefore){  
            SponsorTriggerHandler.insertSponsor(Trigger.New, Trigger.isInsert);    
    }
}