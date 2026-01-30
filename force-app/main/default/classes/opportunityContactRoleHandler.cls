public with sharing class opportunityContactRoleHandler {
    public static List<OpportunityContactRole> generateContactRole(List<Contact> triggerContacts) {
        
        // Initialize list to store new opportunity contact roles
        List<OpportunityContactRole> newConRole = new List<OpportunityContactRole>();

        // Extract unique account IDs from the triggering contacts
        Set<Id> accountId = new Set<Id>();
        for(Contact c : triggerContacts) {
            if(c.AccountId != null) {
                accountId.add(c.AccountId);
            }
        }

        // Query all opportunities associated with the accounts
        List<Opportunity> allOpportunity = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountId];

        // Create opportunity contact roles for each contact-opportunity pairing
        for (Contact c : triggerContacts) {
            for (Opportunity oppo : allOpportunity) {
                if (c.AccountId == oppo.AccountId) {
                    OpportunityContactRole conRole = new OpportunityContactRole();
                    conRole.Role = 'Economic Buyer';
                    conRole.OpportunityId = oppo.Id;
                    conRole.ContactId = c.Id;
                    newConRole.add(conRole);
                }
            }
        }
        
        return newConRole;
    }
}
