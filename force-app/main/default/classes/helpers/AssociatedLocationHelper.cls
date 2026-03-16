public with sharing class AssociatedLocationHelper {
    public AssociatedLocationHelper() {

    }


    public static void verifyTeamMembership() {
        List<AccountTeamMember> novosMembros = new List<AccountTeamMember>();

        Set<Id> userIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Set<String> accUserPair = new Set<String>();

        for (AssociatedLocation location : (List<AssociatedLocation>) Trigger.new) {
            userIds.add(location.User__c);
            accIds.add(location.ParentRecordId);
            accUserPair.add(location.User__c + ':' + location.ParentRecordId);
        }

        for (AccountTeamMember membership : [SELECT AccountId, UserId, TeamMemberRole 
                                                FROM AccountTeamMember 
                                                WHERE AccountId IN :accIds AND UserId IN :userIds]) {
            if (!accUserPair.contains(membership.UserId + ':' + membership.AccountId)){
                novosMembros.add(new AccountTeamMember(AccountId = membership.AccountId, UserId = membership.UserId));
            }
        }

        insert novosMembros;
    }
}