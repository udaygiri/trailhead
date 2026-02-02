public with sharing class caseSupportContactHandler {
    public static void createDefaultSupportContact(List<Case> triggerCase) {
        
        // Create Empty Contact Set() Object.
        List<Contact> newContactList = new List<Contact>();

        // Get all uniqe Account Id.
        Set<Id> relatedAccountId = new Set<Id>();
        for (Case c : triggerCase) {
            if (c.AccountId != null) {
                relatedAccountId.add(c.AccountId);
            }
        }
        
        // Get All contact record child of Account Set() Object.
        List<Contact> relatedContct = [Select Id, AccountId from Contact where AccountId IN :relatedAccountId];

        Set<Id> allLinkAccountId = new Set<Id>();
        for (Contact c : relatedContct) {
            allLinkAccountId.add(c.AccountId);
        }

        for (Case cas : triggerCase) {
            if(!allLinkAccountId.contains(cas.AccountId)){
                Contact c = new Contact();
                c.LastName = 'Support Contact';
                c.AccountId = cas.AccountId;
                newContactList.add(c);
            }
        }
        
        if (!newContactList.isEmpty()) {
            insert newContactList;
        }
    }
}