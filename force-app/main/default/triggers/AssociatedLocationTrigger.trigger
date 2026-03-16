trigger AssociatedLocationTrigger on AssociatedLocation (after insert, after update) {
    new AssociatedLocationTriggerHandler().run();
}