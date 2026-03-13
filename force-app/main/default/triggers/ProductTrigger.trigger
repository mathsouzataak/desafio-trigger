trigger ProductTrigger on Product2 (after insert) {

    ProductTriggerHandler handler = new ProductTriggerHandler();
    if (Trigger.isAfter && Trigger.isInsert) {
        handler.OnAfterInsert(Trigger.new);
    }
}