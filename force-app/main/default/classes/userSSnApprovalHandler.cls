public with sharing class userSSnApprovalHandler {

    public static Id userId = UserInfo.getUserId();

    public static CustomNotificationType cnType = [SELECT Id FROM CustomNotificationType WHERE MasterLabel = 'ssn test'];
    // Main Method
    public static void submitApprovelProcess(List<Project__c> triggerProject) {

        // Get User
        User studentUser = [
            SELECT Id
            FROM User
            WHERE Username = 'students@lt.com'
            LIMIT 1
        ];

        // Get Permission Set
        PermissionSet ps = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'SSN_Number_Visible'
            LIMIT 1
        ];

        

        for (Project__c pr : triggerProject) {

            // Submit for Approval
            if (pr.Approval_Status__c == 'Submitted') {

                
                Approval.ProcessSubmitRequest process =
                    new Approval.ProcessSubmitRequest();

                process.setObjectId(pr.Id);
                process.setComments('Approval sent by Apex Trigger.');
                process.setSubmitterId(userId);
                process.setProcessDefinitionNameOrId('SSN_Approval');

                Approval.ProcessResult result =
                    Approval.process(process);

                if (result.isSuccess()) {
                    msgSend(
                        'Approval Submitted',
                        'Record successfully submitted for approval.'
                    );
                }
            }

            // When Approved assign Permission Set
            else if (pr.Approval_Status__c == 'Approved') {

                System.enqueueJob(
                    new PermissionSetAssignmentQueueable(
                        studentUser.Id,
                        ps.Id
                    )
                );

                msgSend(
                    'Approval Approved',
                    'Permission Set Assigned Successfully.'
                );
            }
        }
    }

    // Email Method
    public static void mailSend(String email, String subject, String body) {

        Messaging.SingleEmailMessage mail =
            new Messaging.SingleEmailMessage();

        mail.setToAddresses(new List<String>{ email });
        mail.setSubject(subject);
        mail.setHtmlBody(body);

        Messaging.sendEmail(
            new List<Messaging.SingleEmailMessage>{ mail }
        );
    }
    public static void msgSend(String subject, String body) {

        
        Messaging.CustomNotification customNotificationObj = new Messaging.CustomNotification();
        customNotificationObj.setBody(body);
        customNotificationObj.setTitle(subject);
        customNotificationObj.setNotificationTypeId(cnType.id);
        customNotificationObj.setSenderId(userId);
        customNotificationObj.setTargetId('a01Qy00001rbMddIAE');
        customNotificationObj.send(new Set<String> {userId});
    }
}
