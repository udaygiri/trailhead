/**
 * autoAddStep
 * 
 * This class is responsible for automatically generating Step records based on WorkPlan type.
 * It provides a reusable method that can be called from triggers or other classes.
 * 
 * Step counts by WorkPlan type:
 * - Preventive Maintenance: 5 steps
 * - Corrective Maintenance: 3 steps
 * - Predictive Maintenance: 4 steps
 */
public with sharing class autoAddStep {

    /**
     * @description Generates a list of Step records based on the provided WorkPlan records.
     * This method processes the input work plans and creates associated step records
     * for each work plan.
     * 
     * @param workPlans A list of WorkPlan__c records to process and generate steps for
     * 
     * @return List<Step__c> A list of generated Step__c records created from the input work plans
     * 
     * @example
     * List<WorkPlan__c> plans = [SELECT Id, Name FROM WorkPlan__c LIMIT 10];
     * List<Step__c> steps = autoAddStep.generateSteps(plans);
     */

    public static List<Step__c> generateSteps(List<WorkPlan__c> workPlans) {

        List<Step__c> StepList = new List<Step__c>();

        // Process each WorkPlan and create appropriate number of steps
        for (WorkPlan__c wp : workPlans) {
            // Create 5 steps for Preventive Maintenance work plans
            if (wp.type__c == 'Preventive Maintenance') {

                for (Integer i = 1; i <= 5; i++) {
                    Step__c step = new Step__c();
                    step.Order__c = i;
                    step.WorkPlan__c = wp.Id;
                    if (i == 1) {
                        step.Status__c = 'In Progress';
                    }
                    StepList.add(step);
                }  
            }
            
            // Create 3 steps for Corrective Maintenance work plans
            else if (wp.type__c == 'Corrective Maintenance') {

                for (Integer i = 1; i <= 3; i++) {
                    Step__c step = new Step__c();
                    step.Order__c = i;
                    step.WorkPlan__c = wp.Id;
                    if (i == 1) {
                        step.Status__c = 'In Progress';
                    }
                    StepList.add(step);
                } 
            }

            // Create 2 steps for Predictive Maintenance work plans
            else if (wp.type__c == 'Predictive Maintenance'){
                for (Integer i = 1; i <= 2; i++) {
                    Step__c step = new Step__c();
                    step.Order__c = i;
                    step.WorkPlan__c = wp.Id;
                    if (i == 1) {
                        step.Status__c = 'In Progress';
                    }
                    StepList.add(step);
                }
            }


        }

        return StepList;
    }
}