trigger AssociatedLocationTrigger on AssociatedLocation (after insert) {
    new AssociatedLocationTriggerHandler().run();
}