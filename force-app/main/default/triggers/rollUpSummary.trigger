trigger rollUpSummary on Opportunity (after insert, after update) {


    List<Account> accountList = rollUpSummary.updateAccountRollup(Trigger.new);

    if (!accountList.isEmpty()) {
        update accountList;
    }

}