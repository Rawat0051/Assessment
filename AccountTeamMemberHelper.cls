/**
* @author Mukesh Rawat
* @date 08/03/2024
* @description  - AccountTeamMemberHelper Class is a trigger Helper class
*					createTeamMembers Method is used to create Team Member record when Account is insert into the database
*					checkPermissionSet Method is used to check that user has the permission set
*					checkMemberType method is used to check that account's Team Members have member type HR or Admin.
*
*					--->Test code coverage provided by the following test class:
*               	- AccountTeamMemberHelper_Test
* CHANGE HISTORY
* ====================================================================================================
* DATE          NAME                    DESCRIPTION
* 
* ====================================================================================================
**/
public class AccountTeamMemberHelper {
    public static void createTeamMembers(List<Account> Accounts){
        
        List<SQX_Team_Members__c> membersToInsert = new List<SQX_Team_Members__c>();
        //system.debug('Accounts' +Accounts);
        for(Account acc: Accounts){
            
            membersToInsert.add(new SQX_Team_Members__c(
                Name = 'Team Member 1',
                Account__c = acc.Id  
            ));
            membersToInsert.add(new SQX_Team_Members__c(
                Name = 'Team Member 2',
                Account__c = acc.Id 
            ));
        }
        insert membersToInsert;
    }
    
    public static void checkPermissionSet(List<Account> Accounts){
        
        Id currentUserId = UserInfo.getUserId();
        List<PermissionSetAssignment> adminPermissionSetAssignments = [SELECT AssigneeId 
                                                                       FROM PermissionSetAssignment
                                                                       WHERE PermissionSet.Name = 'Account_Admin'
                                                                       AND AssigneeId = :currentUserId];
        //System.debug('adminPermissionSetAssignments' +adminPermissionSetAssignments);
        Boolean currentUserHasAdminPermission = !adminPermissionSetAssignments.isEmpty();
        System.debug('currentUserHasAdminPermission' +currentUserHasAdminPermission);
        
        List<SQX_Team_Members__c> TeamMember = [Select Id, 
                                                Member_Type__c 
                                                From SQX_Team_Members__c 
                                                Where Member_Type__c IN ('HR', 'Admin') 
                                                AND Account__c IN : Accounts];	
        
        for (Account acc : Accounts) {
            if(acc.Active__c){
                if (!currentUserHasAdminPermission) {
                    acc.addError('Only users with the Account Admin permission set can activate accounts.');
                }
                else{
                    System.debug('checkMemberType>>');
                    checkMemberType(acc);
                }
            }else{
                system.debug('Pass');
            }
        }
    }
    
    private static void checkMemberType(Account acc){
        
        List<SQX_Team_Members__c> teamMembers = [SELECT Id, 
                                                 Member_Type__c, Account__c 
                                                 FROM SQX_Team_Members__c
                                                 WHERE Account__c =:acc.Id];
        system.debug('teamMembers' +teamMembers);
        
        Boolean hasMemberType = false;
        Boolean hasNotMember = false;
        
        for (SQX_Team_Members__c teamMember : teamMembers) {
            System.debug('IN Loop to teamMember' +teamMember.Member_Type__c);
            if (teamMember.Member_Type__c == 'HR' || teamMember.Member_Type__c == 'Admin' ) {
                hasMemberType = true;
            } else {
                hasNotMember = true;
            }
        }
        if (hasNotMember) {
            acc.addError('Account must have team members with Member Type of HR and Admin.');
        }
        else{
            System.debug('Success' );              
        }
    }
    
}