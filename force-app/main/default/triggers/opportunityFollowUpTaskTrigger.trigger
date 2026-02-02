trigger opportunityFollowUpTaskTrigger on Opportunity (after insert) {

    if (trigger.isInsert) {
        opportunityFollowUpTaskHandler.createTaskUsingMetadata(trigger.new);
    }
}