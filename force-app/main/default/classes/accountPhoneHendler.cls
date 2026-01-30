/* Update Related Records on Field Change
Scenario: When an Account’s Phone field is updated, automatically update the Phone field on all related Contacts to match the new Account phone number. */

public with sharing class accountPhoneHendler {
    public static List<Contact> synceContactNumberToAccountNumber(List<Account> triggerAccounts) {
        List<Contact> newContact = new List<Contact>();

        // Extract Account Ids and create Account Map 
        Set<Id> accountsId = new Set<Id>();
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for (Account acc : triggerAccounts) {
            accountsId.add(acc.Id);
            accountMap.put(acc.Id, acc);
        }

        // Query all Contacts related to the updated Accounts
        List<Contact> relatedContact = [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN :accountsId];

        // Early exit if no related contacts found
        if (relatedContact.isEmpty()) {
            return newContact;
        }

        // Iterate through Contacts and sync Account phone number to Contact phone field
        for (Contact c : relatedContact) {
            Account acc = accountMap.get(c.AccountId);
            if (acc != null) {
                c.Phone = acc.Phone;
                newContact.add(c);
            }
        }

        return newContact;
    }
}