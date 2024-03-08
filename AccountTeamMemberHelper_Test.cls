/**
* @author Mukesh Rawat
* @date 08/03/2024
* @description  - Test class for AccountTeamMemberHelper Class 
*				Apex ClassAccountTeamMemberHelper
* 
* CHANGE HISTORY
* ====================================================================================================
* DATE          NAME                    DESCRIPTION
* 
* ====================================================================================================
**/
@isTest
private class AccountTeamMemberHelper_Test {
    public static id UserId;
    @testSetup
    static void testCreateuser() {
        User u = TestDataFactory.createTestUser(false);
        u.Username = 'Mukeshtest0051@reawaw.com.test';
        insert u;
        system.debug('User' +u);
        System.runAs(u){
        TestDataFactory.assignPermissionSet(u, 'Account_Admin', true);
        }
    }
    
    @isTest
    static void testCreateTeamMembers() {
        User u = [Select id from User where Username = 'Mukeshtest0051@reawaw.com.test'];
 
            List<Account> accList = TestDataFactory.createTestAccounts(true);
            Id accId = accList[0].Id;
        	
            system.runAs(u){
                List<SQX_Team_Members__c> updatedTeamMember = TestDataFactory.UpdateTestTeamMember(accId, true);
                system.debug('Mueksh updatedTeamMember' +updatedTeamMember);
                List<Account> updatedAccList = New List<Account>();
                For(Account acc: accList){
                    acc.Active__c = true;
                    updatedAccList.add(acc);
                }
                Update updatedAccList;
        }  
    } 
}