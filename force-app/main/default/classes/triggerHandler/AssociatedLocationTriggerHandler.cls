public with sharing class AssociatedLocationTriggerHandler extends TriggerHandler {
    public AssociatedLocationTriggerHandler() {

    }

    public override void afterInsert() {
        if (Trigger.new == null || Trigger.new.isEmpty()) {
            return;
        }

        AssociatedLocationHelper.addMembersFromLocations(Trigger.new);
    }

    public override void afterUpdate() {
        if (Trigger.new == null || Trigger.new.isEmpty()) {
            return;
        }

        List<AssociatedLocation> newList = (List<AssociatedLocation>) Trigger.new;
        List<AssociatedLocation> oldList = (List<AssociatedLocation>) Trigger.old;


        List<AssociatedLocation> newUserLocations = new List<AssociatedLocation>();
        List<AssociatedLocation> oldUserLocations = new List<AssociatedLocation>();



        for (Integer i = 0; i < Trigger.new.size(); i++) {
            if (newList[i].User__c != oldList[i].User__c) {
                newUserLocations.add(newList[i]);
                oldUserLocations.add(oldList[i]);
            }
        }

        AssociatedLocationHelper.addMembersFromLocations(newUserLocations);
        AssociatedLocationHelper.removeMembersFromLocations(oldUserLocations);
    }
}