trigger TaskTrigger on Task (before insert) {

     TaskTriggerHandler handler = new TaskTriggerHandler();

    if (Trigger.isBefore && Trigger.isInsert) {
        handler.beforeInsert(Trigger.new);
    }
}
