public with sharing class rollUpSummary {
    
    public static List<Account> updateAccountRollup(List<Opportunity> opportunities) {

        List<Account> accountsToUpdate = new List<Account>();
        
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) {
            return accountsToUpdate;
        }
        
        List<Opportunity> closedWonOpps = [
            SELECT Id, AccountId, Amount, StageName
            FROM Opportunity
            WHERE AccountId IN :accountIds 
            AND StageName = 'Closed Won'
        ];
        
        Map<Id, Decimal> accountAmountMap = new Map<Id, Decimal>();
        
        for (Id accId : accountIds) {
            accountAmountMap.put(accId, 0);
        }
        
        for (Opportunity opp : closedWonOpps) {
            if (accountAmountMap.containsKey(opp.AccountId) && opp.Amount != null) {
                Decimal currentTotal = accountAmountMap.get(opp.AccountId);
                accountAmountMap.put(opp.AccountId, currentTotal + opp.Amount);
            }
        }
        
        List<Account> accountsFromDb = [
            SELECT Id, Total_Amount_Of_Oppo__c
            FROM Account
            WHERE Id IN :accountAmountMap.keySet()
        ];
        
        for (Account acc : accountsFromDb) {
            acc.Total_Amount_Of_Oppo__c = accountAmountMap.get(acc.Id);
            accountsToUpdate.add(acc);
        }
        
        return accountsToUpdate;
    }
}
