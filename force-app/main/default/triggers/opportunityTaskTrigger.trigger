/**
 * Trigger to create tasks for high-value opportunities
 * Executes after opportunity creation
 */
trigger opportunityTaskTrigger on Opportunity (after insert) {
    // Call handler to create tasks for high-value opportunities
    List<Task> newTasks = opportunityTaskHandler.createHighValueTask(trigger.new);
    
    // Insert tasks if any were created
    if (!newTasks.isEmpty()) {
        insert newTasks;
    }
}