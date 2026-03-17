public with sharing class AssociatedLocationTriggerHandler extends TriggerHandler {
    public AssociatedLocationTriggerHandler() {

    }

    public override void afterInsert() {
        if (Trigger.new == null || Trigger.new.isEmpty()) {
            return;
        }

        AssociatedLocationHelper.addNewMembers(Trigger.new);
    }

    public override void afterUpdate() {
        if (Trigger.new == null || Trigger.new.isEmpty()) {
            return;
        }

        List<AssociatedLocation> newUserLocations = new List<AssociatedLocation>();
        List<AssociatedLocation> oldUserLocations = new List<AssociatedLocation>();

        for (Integer = 0; i < novos.size(); i++) {
            if (Trigger.new[i].User__c != Trigger.old[i].User__c) {
                newUserLocations.add(Trigger.new[i]);
                oldUserLocations.add(Trigger.old[i]);
            }
        }

        AssociatedLocationHelper.addNewMembers(newUserLocations);
        AssociatedLocationHelper.removeOldMembers(oldUserLocations);
    }
}