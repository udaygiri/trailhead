public class contactEmailHandler {
	
    public static void checkEmailValidation(List<Contact> triggerContacts){
        
        
        // Get uniqe Account Id from All contact And store in Set() Object.
        Set<Id> AccountsId = new Set<Id>();
        Set<Id> ContactsId = new Set<Id>();
        
        for(Contact cons : triggerContacts){
            if(cons.AccountId != null){
                AccountsId.add(cons.AccountId);
                ContactsId.add(Cons.Id);
            }
        }
        
        // Check Any related Contact is get.
        // 
        if(AccountsId.isEmpty()){return;}
        
        // Get All the Contact from Account set() Object.
        
        List<Contact> allContacts = [SELECT Id, Email, AccountId
                                    FROM Contact 
                                    WHERE Contact.AccountId IN :AccountsId
                                    AND Email != null
                                    AND Id NOT IN :ContactsId];
        

        
        // Init Map() Object.
        
        Map<String, Contact> emailContacts = new  Map<String, Contact>();
        
        // Map Email with Contact.
        
        for(Contact conn : allContacts){
            emailContacts.put(conn.Email, conn);
        }
        
        // Check Email is already map with contact.
        
        for(Contact cons : triggerContacts){
                       
                
            if(cons.Email != null && cons.AccountId != null && emailContacts.containsKey(cons.Email) && cons.AccountId == emailContacts.get(cons.Email).AccountId){
               cons.addError('This email address is already used by another contact under the same account.');
            }
        }
    }
}