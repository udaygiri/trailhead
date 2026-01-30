trigger accountContactTrigger on Account (after insert, after update) {

    if(trigger.isInsert){
        List<Contact> newContact = accountContactHandler.createContactOnFieldInsert(trigger.new);
        if (!newContact.isEmpty()) {
            insert newContact;
        }

    }

    if (trigger.isUpdate) {
        accountContactHandler.createContactOnFieldUpdate(trigger.new, trigger.old);
    }

}