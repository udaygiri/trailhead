// Trigger to handle opportunity deletion operations
trigger deleteOpportunityHandler on Opportunity (before delete) {
    OpportunityDeletionHandler.handleOpportunityDeletion(trigger.old);
}
