/**
 * Handler class for creating tasks based on opportunity amount
 * Creates reminder tasks for high-value opportunities (>= $1M)
 */
public with sharing class opportunityTaskHandler {
    
    /**
     * Creates tasks for high-value opportunities
     * @param triggerOpportunities List of opportunities from trigger
     * @return List of newly created Task records
     */
    public static List<Task> createHighValueTask(List<Opportunity> triggerOpportunities) {
        // Initialize list to store new tasks
        List<Task> newTaskList = new List<Task>();

        // Iterate through opportunities and create tasks for high-value deals
        for (Opportunity oppo : triggerOpportunities) {
            // Check if opportunity amount is >= $1 million
            if (oppo.Amount != null && oppo.Amount >= 1000000) {
                // Create new task for high-value opportunity
                Task newTask = new Task();
                newTask.OwnerId = oppo.OwnerId;          // Assign to opportunity owner
                newTask.Subject = 'Call';                 // Set task subject
                newTask.WhatId = oppo.Id;                 // Link task to opportunity
                newTaskList.add(newTask);
            }
        }
        
        // Return list of created tasks
        return newTaskList;
    }
}