/**
 * Handler class for opportunity deletion validation
 * Prevents deletion of opportunities in 'Closed Won' stage
 */
public with sharing class OpportunityDeletionHandler {
    public static void handleOpportunityDeletion(List<Opportunity> triggerOpportunities) {
        // Iterate through opportunities and validate deletion
        for (Opportunity opportunity : triggerOpportunities) {
            // Prevent deletion of Closed Won opportunities
            if (opportunity.StageName == 'Closed Won') {
                opportunity.addError('Cannot delete opportunity in Closed Won stage.');
            }
        }
    }
}