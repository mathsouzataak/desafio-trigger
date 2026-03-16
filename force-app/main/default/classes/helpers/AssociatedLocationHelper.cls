public with sharing class AssociatedLocationHelper {
    public AssociatedLocationHelper() {

    }

    public static void verifyMembership() {
        List<AccountTeamMember> novosMembros = new List<AccountTeamMember>();

        List<AccountTeamMember> membros = [SELECT AccountId, UserId, TeamMemberRole FROM AccountTeamMember];

        for (AssociatedLocation location : (List<AssociatedLocation>) Trigger.new) {
            Boolean membroExiste = false;
            for (AccountTeamMember member : membros) {
                if (member.UserId == location.User__c && member.AccountId == location.ParentRecordId) {
                    membroExiste = true;
                    break;
                }
            }

            if (!membroExiste) {
                novosMembros.add(new AccountTeamMember(AccountId = location.ParentRecordId, UserId = location.User__c));
            }
        }

        insert novosMembros;
    }
}