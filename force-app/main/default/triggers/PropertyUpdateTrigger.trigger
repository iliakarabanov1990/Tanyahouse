trigger PropertyUpdateTrigger on Property__c (before insert, before update) {
     
    Map<ID, Contact> contMap = new Map<ID, Contact> ([SELECT Id, Name FROM Contact WHERE Id IN (SELECT Property_OwnerId__c FROM Property__c WHERE id IN :Trigger.New)]);
    
    for(Property__c prop : Trigger.New){
        Contact con = contMap.get(prop.Property_OwnerId__c);
        String contactName = con == null ? '': con.Name;
        prop.City__c = 'Минск';
        prop.Address__c = prop.StreetType__c + ' ' + prop.Street__c + ' ' + prop.House__c + '-' + prop.Apartment__c;
        prop.Name = prop.Address__c + ' (' + prop.Beds__c + '-ка) ' + prop.Price__c + ' USD ' + contactName; 
        prop.Baths__c = 1; 
        
        /*GeocodingService.GeocodingAddress addr = new GeocodingService.GeocodingAddress(); 
        addr.street			= prop.House__c + '+' + prop.StreetType__c + '+' + prop.Street__c;
        addr.city			= prop.City__c;
        addr.country		= 'Belarus';
        addr.postalcode		= prop.House__c;
       
        List<GeocodingService.GeocodingAddress> addrs = new List<GeocodingService.GeocodingAddress>();    
        addrs.Add(addr);
        List<GeocodingService.Coordinates> coords = GeocodingService.geocodeAddresses(addrs);
        
        prop.Location__Latitude__s = coords[0].lat;
        prop.Location__Longitude__s = coords[0].lon;*/  
        if(prop.NeedNewCoordinates__c){
            GeocodingService.geocodeAddresses_future(prop.id, prop.House__c, prop.StreetType__c, prop.Street__c, prop.City__c);
        }
        
        prop.NeedNewCoordinates__c = true;
        
        if( prop.Location__Latitude__s != null)
        	prop.Location__Latitude__s = prop.Location__Latitude__s.setScale(8);
        if( prop.Location__Longitude__s != null)
        	prop.Location__Longitude__s = prop.Location__Longitude__s.setScale(8); 
        
        prop.Tags__c = prop.Address__c.Left(5); 
        
        if(trigger.isInsert && String.isBlank(prop.Status__c)){
            prop.Status__c = 'Contracted';
        }
    }
}