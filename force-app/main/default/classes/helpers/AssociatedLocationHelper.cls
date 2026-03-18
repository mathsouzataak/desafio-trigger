public with sharing class AssociatedLocationHelper {
    public AssociatedLocationHelper() {

    }

    public static void onChangeUser() {
        List<AssociatedLocation> newList = (List<AssociatedLocation>) Trigger.new;
        List<AssociatedLocation> oldList = (List<AssociatedLocation>) Trigger.old;

        List<AssociatedLocation> newUserLocations = new List<AssociatedLocation>();
        List<AssociatedLocation> oldUserLocations = new List<AssociatedLocation>();

        for (Integer i = 0; i < newList.size(); i++) {
            if (newList[i].User__c != oldList[i].User__c) {
                newUserLocations.add(newList[i]);
                oldUserLocations.add(oldList[i]);
            }
        }

        if (!oldUserLocations.isEmpty()) {
            addMembersFromLocations(newUserLocations);
            removeMembersWithoutAL(oldUserLocations);
        }
    }

    public static void onChangeAccount() {
        List<AssociatedLocation> newList = (List<AssociatedLocation>) Trigger.new;
        List<AssociatedLocation> oldList = (List<AssociatedLocation>) Trigger.old;

        List<AssociatedLocation> newAccountLocations = new List<AssociatedLocation>();
        List<AssociatedLocation> oldAccountLocations = new List<AssociatedLocation>();

        for (Integer i = 0; i < newList.size(); i++) {
            if (newList[i].ParentRecordId != oldList[i].ParentRecordId) {
                newAccountLocations.add(newList[i]);
                oldAccountLocations.add(oldList[i]);
            }
        }

        if (!oldAccountLocations.isEmpty()) {
            changeMemberToNewAccountFromLocation(oldAccountLocations, newAccountLocations);
            removeMembersWithoutAL(oldAccountLocations);
        }
    }


    public static void addMembersFromLocations(List<AssociatedLocation> newUserLocations) {
        List<AccountTeamMember> newMembers = new List<AccountTeamMember>();

        Set<Id> userIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();

        for (AssociatedLocation location : newUserLocations) {
            userIds.add(location.User__c);
            accIds.add(location.ParentRecordId);
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
        Set<String> pairForDeletion = new Set<String>();
        for (AssociatedLocation location : oldUserLocations) {
            if (!associatedLocPairs.contains(createIdPair(location.User__c, location.ParentRecordId))) {
                userIdsForDeletion.add(location.User__c);
                accIdsForDeletion.add(location.ParentRecordId);
                pairForDeletion.add(createIdPair(location.User__c, location.ParentRecordId));
            }
        }

        for (AccountTeamMember member : [SELECT Id, AccountId, UserId, TeamMemberRole 
                                            FROM AccountTeamMember 
                                            WHERE UserId IN :userIdsForDeletion AND AccountId IN :accIdsForDeletion]) {
            if (pairForDeletion.contains(createIdPair(member.UserId, member.AccountId))) {
                oldMembers.add(member);
            }
        }

        delete oldMembers;
    }

    public static void changeMemberToNewAccountFromLocation(List<AssociatedLocation> oldAccountLocations, List<AssociatedLocation> newAccountLocations) {
        List<AccountTeamMember> members = new List<AccountTeamMember>();

        Set<Id> userIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Set<String> accUserPair = new Set<String>();

        for (AssociatedLocation location : oldAccountLocations) {
            userIds.add(location.User__c);
        }

        Set<String> associatedLocPairs = new Set<String>();
        for (AssociatedLocation location : [SELECT Id, ParentRecordId, User__c
                                            FROM AssociatedLocation
                                            WHERE User__c IN :userIds]) {
            associatedLocPairs.add(createIdPair(location.User__c, location.ParentRecordId));
        }


        for (Integer i = 0; i < oldAccountLocations.size(); i++) {
            if (!associatedLocPairs.contains(createIdPair(oldAccountLocations[i].User__c, oldAccountLocations[i].ParentRecordId))) {
                members.add(new AccountTeamMember(UserId = oldAccountLocations[i].User__c, AccountId = newAccountLocations[i].ParentRecordId));
            }
        }

        insert members;
    }

    private static String createIdPair(Id userId, Id accId) {
        return userId + ':' + accId;
    } 
}