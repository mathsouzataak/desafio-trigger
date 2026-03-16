public with sharing class AssociatedLocationHelper {
    public AssociatedLocationHelper() {

    }


    public static void verifyTeamMembership() {
        List<AccountTeamMember> novosMembros = new List<AccountTeamMember>();

        List<AccountTeamMember> memberships = [SELECT AccountId, UserId, TeamMemberRole FROM AccountTeamMember];

        for (AssociatedLocation location : (List<AssociatedLocation>) Trigger.new) {
            if (locationUserIsMemberOfAccountTeam(location, memberships)) {
                novosMembros.add(new AccountTeamMember(AccountId = location.ParentRecordId, UserId = location.User__c));
            }
        }

        insert novosMembros;
    }

    private static Boolean locationUserIsMemberOfAccountTeam(AssociatedLocation location, List<AccountTeamMember> memberships) {
        for (AccountTeamMember member : memberships) {
            if (member.UserId == location.User__c && member.AccountId == location.ParentRecordId) {
                return true;
            }
        }

        return false;
    }
}