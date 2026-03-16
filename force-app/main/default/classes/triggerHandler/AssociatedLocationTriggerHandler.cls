public with sharing class AssociatedLocationTriggerHandler extends TriggerHandler {
    public AssociatedLocationTriggerHandler() {

    }

    public override void afterInsert() {
        if (Trigger.new == null || Trigger.new.isEmpty()) {
            return;
        }

        AssociatedLocationHelper.verifyTeamMembership();
    }

    public override void afterUpdate() {
        // if (Trigger.new == null || Trigger.new.isEmpty()) {
        //     return;
        // }

        // List<AssociatedLocation> novos = Trigger.new;
        // List<AssociatedLocation> velhos = Trigger.old;

        // for (Integer = 0; i < novos.size(); i++) {
        //     if (novos[i].User__c != velhos[i].User__c) {

        //     }
        // }

    }
}