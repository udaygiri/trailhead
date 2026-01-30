trigger contactEmailHandl on Contact (before insert) {
    
    if(Trigger.isBefore){
        contactEmailHandler.checkEmailValidation(Trigger.new);
    }

}