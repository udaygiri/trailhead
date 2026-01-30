public with sharing class accountContactHandler {
    public static List<Contact> createContactOnFieldInsert(List<Account> triggerAccounts) {
        List<contact> newContacts = new List<Contact>();
        Map<Id, List<String>> contactNameList = new Map<Id, List<String>>();

        for (Account acc : triggerAccounts) {
            if (acc.Contacts_Name__c != null) {  
                contactNameList.put(acc.Id, acc.Contacts_Name__c.split(','));
            }
        }

        for (Account acc : triggerAccounts) {
            if(contactNameList.containsKey(acc.Id)){
                for (String cName : contactNameList.get(acc.Id)) {
                    Contact c = new Contact();
                    c.LastName = cName;
                    c.AccountId = acc.Id;
                    newContacts.add(c);
                }
            }
        }

        return newContacts;

    }

    public static void createContactOnFieldUpdate(List<Account> newAccounts, List<Account> oldAccounts) {
        // Maps for old and new contact names per account
        Map<Id, Set<String>> oldNamesMap = new Map<Id, Set<String>>();
        Map<Id, Set<String>> newNamesMap = new Map<Id, Set<String>>();
        
        // Build maps, treating null as empty set
        for (Account acc : oldAccounts) {
            Set<String> names = new Set<String>();
            if (acc.Contacts_Name__c != null) {
                names.addAll(acc.Contacts_Name__c.split(','));
            }
            oldNamesMap.put(acc.Id, names);
        }
        
        for (Account acc : newAccounts) {
            Set<String> names = new Set<String>();
            if (acc.Contacts_Name__c != null) {
                names.addAll(acc.Contacts_Name__c.split(','));
            }
            newNamesMap.put(acc.Id, names);
        }
        
        // Collect all names to delete and insert
        Set<String> allToDelete = new Set<String>();
        Map<String, Id> namesToInsertWithAccount = new Map<String, Id>();
        
        for (Id accId : newNamesMap.keySet()) {
            Set<String> oldNames = oldNamesMap.get(accId) != null ? oldNamesMap.get(accId) : new Set<String>();
            Set<String> newNames = newNamesMap.get(accId);
            
            // Names to delete: in old but not in new
            Set<String> toDelete = new Set<String>(oldNames);
            toDelete.removeAll(newNames);
            allToDelete.addAll(toDelete);
            
            // Names to insert: in new but not in old
            Set<String> toInsert = new Set<String>(newNames);
            toInsert.removeAll(oldNames);
            for (String name : toInsert) {
                namesToInsertWithAccount.put(name, accId);
            }
        }
        
        // Delete contacts
        if (!allToDelete.isEmpty()) {
            List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE LastName IN :allToDelete AND AccountId IN :newNamesMap.keySet()];
            delete contactsToDelete;
        }
        
        // Insert new contacts
        if (!namesToInsertWithAccount.isEmpty()) {
            List<Contact> newContacts = new List<Contact>();
            for (String name : namesToInsertWithAccount.keySet()) {
                Contact c = new Contact();
                c.LastName = name;
                c.AccountId = namesToInsertWithAccount.get(name);
                newContacts.add(c);
            }
            insert newContacts;
        }

    }
}