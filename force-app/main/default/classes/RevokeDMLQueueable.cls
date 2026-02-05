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
                userSSnApprovalHandler.msgSend('Success', 'Permission Set Assignment Deleted Successfully');
            }
            else{
                userSSnApprovalHandler.msgSend('Error', 'Permission Set Assignment not found');
            }
        }
    }