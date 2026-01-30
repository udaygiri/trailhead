/**
 * workPlanSetter
 * 
 * Trigger: Executes after WorkPlan records are inserted or updated.
 * Purpose: Automatically generates Step records based on the WorkPlan type.
 * 
 * Execution:
 * - after insert: Creates initial steps when new WorkPlans are created
 * - after update: Creates steps when existing WorkPlans are modified
 */
trigger workPlanSetter on WorkPlan__c (after insert) {
    
    // Generate steps for all new/updated WorkPlans
    List<Step__c> StepList = autoAddStep.generateSteps(Trigger.new);
    
    // Insert the newly created steps only if the list has items
    if (!StepList.isEmpty()) {
        insert StepList;
    }
}