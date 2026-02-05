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
            try {
                
                System.enqueueJob(new RevokeDMLQueueable(userId, psId));

                userSSnApprovalHandler.msgSend(
                    'Message',
                    'Permission Set Revoke Scheduled Successfully.'
                );
            } catch (Exception e) {
                userSSnApprovalHandler.msgSend('Error', e.getMessage());
            }
            
            // Clean up the scheduled job itself after execution
            System.abortJob(sc.getTriggerId());
        }
    }