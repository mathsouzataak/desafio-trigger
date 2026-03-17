public with sharing class AssociatedLocationHelper {
    public AssociatedLocationHelper() {

    }


    public static void addMembersFromLocations(List<AssociatedLocation> newUserLocations) {
        List<AccountTeamMember> newMembers = new List<AccountTeamMember>();

        Set<Id> userIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Set<String> accUserPair = new Set<String>();

        for (AssociatedLocation location : newUserLocations) {
            userIds.add(location.User__c);
            accIds.add(location.ParentRecordId);
            accUserPair.add(createIdPair(location.User__c, location.ParentRecordId));
        }

        for (AccountTeamMember membership : [SELECT AccountId, UserId, TeamMemberRole 
                                                FROM AccountTeamMember 
                                                WHERE AccountId IN :accIds AND UserId IN :userIds]) {
            if (!accUserPair.contains(createIdPair(membership.UserId, membership.AccountId))){
                newMembers.add(membership);
            }
        }

        insert newMembers;
    }

    public static void removeMembersFromLocations(List<AssociatedLocation> oldUserLocations) {
        List<AccountTeamMember> oldMembers = new List<AccountTeamMember>();

        Set<Id> userIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Set<String> accUserPair = new Set<String>();

        for (AssociatedLocation location : oldUserLocations) {
            userIds.add(location.User__c);
            accIds.add(location.ParentRecordId);
            accUserPair.add(createIdPair(location.User__c, location.ParentRecordId));
        }

        for (AccountTeamMember membership : [SELECT AccountId, UserId, TeamMemberRole 
                                                FROM AccountTeamMember 
                                                WHERE AccountId IN :accIds AND UserId IN :userIds]) {
            if (accUserPair.contains(createIdPair(membership.UserId, membership.AccountId))){
                oldMembers.add(membership);
            }
        }

        delete oldMembers;
    }

    private static String createIdPair(Id id1, Id id2) {
        return id1 + ':' + id2;
    } 
}