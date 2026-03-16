public with sharing class AssociatedLocationTriggerHandler extends TriggerHandler {
    public AssociatedLocationTriggerHandler() {

    }

    public override void afterInsert() {
        AssociatedLocationHelper.verifyTeamMembership();
    }
}