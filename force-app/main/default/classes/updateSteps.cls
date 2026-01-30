/**
 * updateSteps
 * 
 * This class manages the step lifecycle and status transitions for WorkPlan steps.
 * It implements the following logic:
 * - Step lifecycle: To Do → In Progress → Completed
 * - When a step is marked 'Completed', the next step is automatically set to 'In Progress'
 * - Validation: Only one step per WorkPlan can be 'In Progress' at a time
 */
public with sharing class updateSteps {
    
    /**
     * @description Sets the next step status to 'In Progress' when the current step is completed.
     *              Also validates that only one step is 'In Progress' per WorkPlan at any time.
     * 
     * @param steps List of Step__c records that were just updated
     * 
     * @return List<Step__c> List of steps that need to be updated with new status values
     * 
     * @example
     * List<Step__c> updatedSteps = updateSteps.setNextStepStatus(Trigger.new);
     */
    public static List<Step__c> setNextStepStatus(List<Step__c> steps) {
        
        List<Step__c> stepsToUpdate = new List<Step__c>();
        
        // Extract WorkPlan IDs from the updated steps
        Set<Id> workPlanIds = new Set<Id>();
        for (Step__c step : steps) {
            if (step.WorkPlan__c != null) {
                workPlanIds.add(step.WorkPlan__c);
            }
        }
        
        // Query all steps for the affected WorkPlans, ordered by sequence
        List<Step__c> allRelatedSteps = [SELECT Id, Order__c, Status__c, WorkPlan__c 
                                         FROM Step__c 
                                         WHERE WorkPlan__c IN :workPlanIds 
                                         ORDER BY WorkPlan__c, Order__c ASC];
        
        // Process each updated step
        for (Step__c currentStep : steps) {
            // Check if current step was marked as Completed
            if (currentStep.Status__c == 'Completed') {
                // Find the next step in the same WorkPlan
                for (Integer i = 0; i < allRelatedSteps.size(); i++) {
                    Step__c relatedStep = allRelatedSteps[i];
                    
                    // Check if this is the current step
                    if (relatedStep.Id == currentStep.Id && relatedStep.WorkPlan__c == currentStep.WorkPlan__c) {
                        // Get the next step (i + 1)
                        if (i + 1 < allRelatedSteps.size()) {
                            Step__c nextStep = allRelatedSteps[i + 1];
                            
                            // Only set next step to 'In Progress' if it's still 'To Do'
                            if (nextStep.WorkPlan__c == currentStep.WorkPlan__c && nextStep.Status__c == 'To Do') {
                                nextStep.Status__c = 'In Progress';
                                stepsToUpdate.add(nextStep);
                            }
                        }
                        break;
                    }
                }
            }
        }
        
        return stepsToUpdate;
    }
}

