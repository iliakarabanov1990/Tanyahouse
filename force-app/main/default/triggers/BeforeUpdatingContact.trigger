trigger BeforeUpdatingContact on Contact (before insert, before update) {
   
    if(trigger.isInsert){
        List<Contact> listOfContact = new List<Contact>();            
            
        for (Contact conObj : trigger.new)   
        {  
            if (String.isBlank(conObj.accountid))   
            {  
                listOfContact.add(conObj);  
            }  
        }   
            
        if (listOfContact.size() > 0)
        {  
            List<Account> createNewAcc = new List<Account>();
            Map<String, Contact> conNameKeys = new Map<String, Contact>();
            
            for (Contact con : listOfContact)   
            {  
                String accountName = (con.firstname == null ? '' : con.firstname + ' ') + con.lastname;  
                conNameKeys.put(accountName, con);                      
                Account accObj = new Account();  
                accObj.Name = accountName;
                accObj.Phone= con.Phone;
                createNewAcc.add(accObj);  
            }  
            
            insert createNewAcc;  
            
            for (Account acc : createNewAcc)   
            {                
                if (conNameKeys.containsKey(acc.Name))   
                {  
                    conNameKeys.get(acc.Name).accountId = acc.Id;  
                }  
            }  
        } 
    } 
       
}