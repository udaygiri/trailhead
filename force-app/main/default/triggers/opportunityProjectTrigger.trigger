trigger opportunityProjectTrigger on Opportunity (after update) {

    List<Project__c> newProject = opportunityProjectHandler.createProjectOnCloseWon(trigger.new);
    if (!newProject.isEmpty()) {
        insert newProject;
    }

}