trigger AccountTrigger on Account (after insert, before update) {
    if (Trigger.isAfter && Trigger.isInsert) {
        	AccountTeamMemberHelper.createTeamMembers(Trigger.new);
    }
    else if (Trigger.isBefore && Trigger.isUpdate) {
        	AccountTeamMemberHelper.checkPermissionSet(Trigger.new);
    }

}