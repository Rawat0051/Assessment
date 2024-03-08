/**
* @author Mukesh Rawat
* @date 08/03/2024
* @description  Test data factory for all the test classes.
*
* CHANGE HISTORY
* ====================================================================================================
* DATE          NAME                    DESCRIPTION
* N/A           N/A                     N/A
* ====================================================================================================
**/
@isTest
public class TestDataFactory {
    public static List<Account> createTestAccounts(Boolean doInsert){
        List<Account> testAccounts = new List<Account>();   
          testAccounts.add(new Account(Name = 'Test Account '));      
        if(doInsert){
            insert testAccounts;
        }
        
        return testAccounts;
    } 
    
    public static User createTestUser(Boolean doInsert){
        Id p = [select id from profile where name='system Administrator'].id;
        
        User user = new User(alias = 'test1234', email= 'testemail4@testclass.com.they',
                             emailencodingkey='UTF-8', lastname='Testing4', Firstname = 'User4', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             timezonesidkey='America/Los_Angeles', username='testemail4'/*+string.valueOf(system.now())*/+'@gmail.com');
        if(doInsert){
            insert user;
        }
        
        return user;
    } 
    
    
    public static void assignPermissionSet(User user, String permissionSetName, Boolean doInsert) {
        Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName].Id;
        PermissionSetAssignment psa = new PermissionSetAssignment(
            PermissionSetId = permissionSetId,
            AssigneeId = user.Id
        );
        if(doInsert){
        	insert psa;
        }
    }
    public static List<SQX_Team_Members__c> UpdateTestTeamMember(Id accId, Boolean doInsert){
        List<SQX_Team_Members__c> TeamMembers = [Select Id, Member_Type__c From SQX_Team_Members__c Where Account__c  =: accId];
        	System.debug('TeamMembersTeamMembers' +TeamMembers);
            List<SQX_Team_Members__c> updatedTeamMember = New List<SQX_Team_Members__c>();
            for(SQX_Team_Members__c teamMember: TeamMembers){
                teamMember.Member_Type__c = 'HR';
                updatedTeamMember.add(teamMember);
            }
            update updatedTeamMember;
        return updatedTeamMember;
    } 
}