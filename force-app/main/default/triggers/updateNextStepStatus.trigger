/**
 * updateNextStepStatus
 * 
 * Trigger: Executes after Step__c records are updated.
 * Purpose: Manages step lifecycle transitions by automatically advancing the next step to 'In Progress'
 *          when the current step is marked as 'Completed'.
 * 
 * Step Lifecycle:
 * - To Do: Initial status when step is created
 * - In Progress: Set automatically when previous step is completed
 * - Completed: User marks step as completed, which triggers next step to become 'In Progress'
 */
trigger updateNextStepStatus on Step__c (after update) {

    // Get updated steps with new status values
    List<Step__c> stepsToUpdate = updateSteps.setNextStepStatus(Trigger.new);
    
    // Update the steps if any transitions need to be made
    if (!stepsToUpdate.isEmpty()) {
        update stepsToUpdate;
    }

}
