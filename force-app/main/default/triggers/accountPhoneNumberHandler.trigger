/* Update Related Records on Field Change
Scenario: When an Account’s Phone field is updated, automatically update the Phone field on all related Contacts to match the new Account phone number. */

trigger accountPhoneNumberHandler on Account (after update) {
    // Sync contact phone numbers with account phone numbers
    List<Contact> updateContList = accountPhoneHendler.synceContactNumberToAccountNumber(trigger.new);

    // Update contacts if list is not empty
    if (!updateContList.isEmpty()) {
        update updateContList;
    }
}