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

        AssociatedLocationHelper.onChangeUser();

        AssociatedLocationHelper.onChangeAccount();
    }
}