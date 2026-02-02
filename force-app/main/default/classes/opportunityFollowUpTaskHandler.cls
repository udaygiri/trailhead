public with sharing class opportunityFollowUpTaskHandler {
    public static void createTaskUsingMetadata(List<Opportunity> triggerOpportunities) {

        // Cretae List for task
        List<Task> newTaskList = new List<Task>();

        // Getting Amount From Custome MetaData.
        List<opportunity_follow_up_task__mdt> mData = [Select opportunity_amount__c From opportunity_follow_up_task__mdt LIMIT 1];
        Decimal opportunityAmaout = mData[0].opportunity_amount__c;

        // check if any amount get from MetaData
        if (opportunityAmaout == null) {
            return ;
        }

        // Loop through opportunities and create tasks for those exceeding the threshold amount
        for (Opportunity oppo : triggerOpportunities) {
            // Check if opportunity amount exceeds the metadata threshold
            if(oppo.Amount > opportunityAmaout){
            // Create new task linked to the opportunity
            Task newTask = new Task();
            newTask.WhatId = oppo.Id;
            newTask.subject = 'Email';
            newTask.OwnerId = oppo.OwnerId;
            // Add task to list for batch insertion
            newTaskList.add(newTask);
            }
        }

        // Check if Task List is empty or not.
        if (!newTaskList.isEmpty()) {
            insert newTaskList;
        }

    }
}