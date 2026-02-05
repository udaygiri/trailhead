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