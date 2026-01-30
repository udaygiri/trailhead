trigger opportunityContactRoleHandler on Contact (after insert) {

    // Generate opportunity contact roles for newly inserted contacts
    List<opportunityContactRole> newRole = opportunityContactRoleHandler.generateContactRole(trigger.new);
    
    // Insert the new roles if any were generated
    if (!newRole.isEmpty()) {
        insert newRole;
    }

}
