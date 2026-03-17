public with sharing class AssociatedLocationHelper {
    public AssociatedLocationHelper() {

    }


    public static void addMembersFromLocations(List<AssociatedLocation> newUserLocations) {
        List<AccountTeamMember> newMembers = new List<AccountTeamMember>();

        Set<Id> userIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        // Set<String> accUserPair = new Set<String>();

        for (AssociatedLocation location : newUserLocations) {
            userIds.add(location.User__c);
            accIds.add(location.ParentRecordId);
            // accUserPair.add(createIdPair(location.User__c, location.ParentRecordId));
        }


        Set<String> membershipPairs = new Set<String>();
        for (AccountTeamMember member : [SELECT Id, AccountId, UserId, TeamMemberRole 
                                                FROM AccountTeamMember 
                                                WHERE UserId IN :userIds AND AccountId IN :accIds]) {
            membershipPairs.add(createIdPair(member.UserId, member.AccountId));
        }

        for (AssociatedLocation location : newUserLocations) {
            if (!membershipPairs.contains(createIdPair(location.User__c, location.ParentRecordId))) {
                newMembers.add(new AccountTeamMember(UserId = location.User__c, AccountId = location.ParentRecordId));
            }
        }


        insert newMembers;
    }

    public static void removeMembersWithoutAL(List<AssociatedLocation> oldUserLocations) {
        List<AccountTeamMember> oldMembers = new List<AccountTeamMember>();

        Set<Id> userIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Set<String> accUserPair = new Set<String>();

        for (AssociatedLocation location : oldUserLocations) {
            userIds.add(location.User__c);
            accIds.add(location.ParentRecordId);
            accUserPair.add(createIdPair(location.User__c, location.ParentRecordId));
        }

        Set<String> associatedLocPairs = new Set<String>();
        for (AssociatedLocation location : [SELECT Id, ParentRecordId, User__c
                                            FROM AssociatedLocation
                                            WHERE User__c IN :userIds AND ParentRecordId IN :accIds]) {
            associatedLocPairs.add(createIdPair(location.User__c, location.ParentRecordId));
        }

        Set<Id> userIdsForDeletion = new Set<Id>();
        Set<Id> accIdsForDeletion = new Set<Id>();
        for (AssociatedLocation location : oldUserLocations) {
            if (!associatedLocPairs.contains(createIdPair(location.User__c, location.ParentRecordId))) {
                userIdsForDeletion.add(location.User__c);
                accIdsForDeletion.add(location.ParentRecordId);
            }
        }

        oldMembers = [SELECT Id, AccountId, UserId, TeamMemberRole 
                        FROM AccountTeamMember 
                        WHERE UserId IN :userIdsForDeletion AND AccountId IN :accIdsForDeletion];

        delete oldMembers;
    }

    private static String createIdPair(Id userId, Id accId) {
        return userId + ':' + accId;
    } 
}