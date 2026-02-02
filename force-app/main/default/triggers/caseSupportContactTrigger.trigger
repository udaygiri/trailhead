trigger caseSupportContactTrigger on Case (after insert) {

    if (trigger.isInsert) {
        caseSupportContactHandler.createDefaultSupportContact(trigger.new);
    }
}