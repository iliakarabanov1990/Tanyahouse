trigger LeadUpdateTrigger on Lead (before insert, before update) {
     
    if(!trigger.isInsert)
        return;

    for(Lead lead : Trigger.New){
        
        lead.Company = lead.LastName; 
        
        if(String.isBlank(lead.Address__c)) 
			lead.Address__c = lead.StreetType__c + ' ' + lead.Street__c + ' ' + lead.House__c + '-' + lead.Apartment__c;
        
    }
    
}