trigger ProductTrigger on Product2 (after insert) {

    ProductTriggerHandler handler = new ProductTriggerHandler();
    if (Trigger.isAfter && Trigger.isInsert) {
        new ProductTriggerHandler().run();
    }
}