public with sharing class opportunityProjectHandler {
    public static List<Project__c > createProjectOnCloseWon(List<Opportunity> triggerOpportunities) {

        List<Project__c> newListProject = new List<Project__c>();

        for(Opportunity oppo : triggerOpportunities){
            if (oppo.StageName == 'Closed Won')  {  

                Project__c np = new Project__c();
                np.Opportunity_Description__c = oppo.Description;
                np.Opportunity_Date__c = oppo.CloseDate;
                np.Opportunity__c = oppo.Id;

                newListProject.add(np);
            }
        }

        return newListProject;
    }
}