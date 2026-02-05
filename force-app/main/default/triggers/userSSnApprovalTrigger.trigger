trigger userSSnApprovalTrigger on Project__c (after insert, after update) {
    userSSnApprovalHandler.submitApprovelProcess(trigger.new);
}