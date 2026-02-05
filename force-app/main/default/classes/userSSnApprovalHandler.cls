public with sharing class userSSnApprovalHandler {

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
                process.setSubmitterId(UserInfo.getUserId());
                process.setProcessDefinitionNameOrId('SSN_Approval');

                Approval.ProcessResult result =
                    Approval.process(process);

                if (result.isSuccess()) {
                    mailSend(
                        'udaygiri.aparnathi@logicrain.com',
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

                mailSend(
                    'udaygiri.aparnathi@logicrain.com',
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

    // Queueable Class for Permission Set Assignment
    public class PermissionSetAssignmentQueueable implements Queueable {

        private Id userId;
        private Id psId;

        public PermissionSetAssignmentQueueable(Id userId, Id psId) {
            this.userId = userId;
            this.psId = psId;
        }

        public void execute(QueueableContext qc) {

            PermissionSetAssignment psa =
                new PermissionSetAssignment();

            psa.AssigneeId = userId;
            psa.PermissionSetId = psId;

            insert psa;

            // Schedule revoke after 5 minutes
            Datetime runTime = System.now().addMinutes(3);

            String cronExp =
                runTime.second() + ' ' +
                runTime.minute() + ' ' +
                runTime.hour() + ' ' +
                runTime.day() + ' ' +
                runTime.month() + ' ? ' +
                runTime.year();

            String jobName =
                'RevokePS_' + userId + '_' + System.currentTimeMillis();

            System.schedule(
                jobName,
                cronExp,
                new revokePermissionSetSchedule(userId, psId)
            );
        }
    }

    // Scheduler Class for Permission Set Revoke
    public class revokePermissionSetSchedule implements Schedulable {
        private Id userId;
        private Id psId;

        public revokePermissionSetSchedule(Id userId, Id psId) {
            this.userId = userId;
            this.psId = psId;
        }

        public void execute(SchedulableContext sc) {
            // Use a background process to avoid Mixed DML and permission issues
            System.enqueueJob(new RevokeDMLQueueable(userId, psId));
            
            // Clean up the scheduled job itself after execution
            System.abortJob(sc.getTriggerId());
        }
    }

    // Separate Queueable to perform the actual Delete
    public class RevokeDMLQueueable implements Queueable {
        private Id userId;
        private Id psId;

        public RevokeDMLQueueable(Id uId, Id pId) {
            this.userId = uId;
            this.psId = pId;
        }

        public void execute(QueueableContext qc) {
            List<PermissionSetAssignment> psaList = [
                SELECT Id FROM PermissionSetAssignment 
                WHERE PermissionSetId = :psId
            ];
            if (!psaList.isEmpty()) {
                delete psaList;
            }
        }
    }
}
