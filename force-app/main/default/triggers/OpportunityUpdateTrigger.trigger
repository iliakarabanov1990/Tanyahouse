trigger OpportunityUpdateTrigger on Opportunity (before insert) {
   
    for(Opportunity opp : Trigger.New){
        if(trigger.isInsert && opp.CloseDate == Date.today()){
 			opp.CloseDate = Date.today().addMonths(1);
        }
    }

}