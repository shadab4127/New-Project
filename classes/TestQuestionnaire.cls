@isTest
public class TestQuestionnaire{
	@TestSetup 
    static void setup(){
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User'].Id;
        Account a = TestUtility.createAccount('Test Account');
        insert a;
        Contact c = TestUtility.createContact(a.Id);
        insert c;
        User u = TestUtility.createCommunityUser(c.Id,profileId,'test1@gmail.com','User');
        insert u;
        Category__c cat = TestUtility.createCategory();
        insert cat;
        TestUtility.getPermissions(u.Id);
        Progress_Bar_Question__c p1 = new Progress_Bar_Question__c(Object_Name__c = 'Contact',Field_Api_Name__c = 'Phone',Question__c = 'Please enter phone',Weightage__c = 25);
        Progress_Bar_Question__c p2 = new Progress_Bar_Question__c(Object_Name__c = 'Contact',Field_Api_Name__c = 'Email',Question__c = 'Please enter email',Weightage__c = 21);
        Progress_Bar_Question__c p3 = new Progress_Bar_Question__c(Object_Name__c = 'User',Field_Api_Name__c = 'Title',Question__c = 'Please enter title',Weightage__c = 11);
        insert new list<Progress_Bar_Question__c>{p1,p2,p3};
        
    }
    @isTest static void testGetQuuestion(){
        String objectn; String fieldn; String quest;
        Decimal weight; Decimal sortn;
        list<Questionnaire.wrapper> wrlist = new list<Questionnaire.wrapper>();
        Progress_Bar_Question__c prog = [SELECT Id,Object_Name__c From Progress_Bar_Question__c limit 1];
        Questionnaire.wrapper wr = new Questionnaire.wrapper();
        wr.field = fieldn;
        wr.fieldValue = 'Test';
        wr.listsize = 30;
        wr.objectn=objectn;
        wr.queId = prog.Id;
        User u = [SELECT Id FROM User WHERE UserName='test1@gmail.com'];
        Test.startTest();
        System.runAs(u){
            Questionnaire q = new Questionnaire(objectn,fieldn,quest,weight,sortn);
            Questionnaire.getQue(u.Id);
            q.compareTo(objectn);
        }
        Test.stopTest();
        Progress_Bar_Question__c progress = [SELECT Id,Object_Name__c,Field_Api_Name__c From Progress_Bar_Question__c WHERE Weightage__c = 21];
        System.assertEquals(progress.Object_Name__c, 'Contact');
    }
    @isTest static void testGetCalculateactual(){
        Decimal returnWeightage;
      	User u = [SELECT Id FROM User WHERE username ='test1@gmail.com'];
 		Test.startTest();
        System.runAs(u){
        	returnWeightage = Questionnaire.getcalculateactual(u.Id);
        }
        Test.StopTest();
        System.assertEquals(56, returnWeightage);
    }
    @isTest static void testReturnrecords(){
        String returnValues='';
        User user=[select id,contactid,accountid from User where username ='test1@gmail.com'];
        Progress_Bar_Question__c p = [SELECT Id,Object_Name__c,Field_Api_Name__c From Progress_Bar_Question__c WHERE Weightage__c = 21];
        Test.startTest();
            System.runAs(user){
                returnValues = Questionnaire.returnrecords(p.Object_Name__c, p.Field_Api_Name__c);
            }
        Test.StopTest();
		System.assertEquals('test@gmail.com',returnValues);  
    }
    @isTest static void testcreateBadges(){
        String returnValues='';
        Id profId=[SELECT Id FROM Profile WHERE Name='Standard Platform User'].Id;
        User user=[select id,contactid,accountid from User where username ='test1@gmail.com'];
        System.debug('User'+user.Id);
		User usr = TestUtility.createUser('', profId, 'test234@user.com', 'abc1');
        insert usr;
        NetworkMember membership = [SELECT networkID, memberID FROM NetworkMember WHERE memberID = :user.id];
        System.runAs(user){
        Document document;
        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'image/jpeg';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = UserInfo.getUserId();
        insert document;
        WorkBadgeDefinition  wrkDef = new WorkBadgeDefinition();
        wrkDef.Name             = 'Test Badge';
        wrkDef.Description      = 'Test Badge';
        wrkDef.ImageUrl         = document.Id;  
        wrkDef.IsActive         = True;
        wrkDef.NetworkId        = membership.networkID;    
        Insert wrkDef;

        WorkThanks  wrkThanks   = new WorkThanks();
        wrkThanks.GiverId       = UserInfo.getUserId();
        wrkThanks.Message       = 'Test Thanks';
        wrkThanks.OwnerId       = User.Id;
        wrkThanks.NetworkId     = wrkDef.NetworkId;
        Insert wrkThanks;
      	WorkBadge  wrkBadge = new WorkBadge ();
        wrkBadge.DefinitionId     = wrkDef.Id;
        wrkBadge.RecipientId      = usr.Id;
        wrkBadge.SourceId         = wrkThanks.Id;
        wrkBadge.NetworkId        = wrkThanks.NetworkId;
        Insert wrkBadge;
        Test.startTest();
           returnValues = Questionnaire.createBadges(10);
        Test.stopTest();
        }
        System.assertEquals('Success', returnValues);
    }
    @isTest static void testupdateRecords(){
        User user=[select id,contactid,accountid from User where username ='test1@gmail.com'];
        Contact c = [SELECT Id,Phone FROM Contact WHERE Id =:user.contactid];
        c.Phone ='1234567';
        Test.startTest();
        update c;
        System.runAs(user){
        	System.debug(Questionnaire.updateRecords());
        }
        Test.stopTest();
        Contact c1 = [SELECT Id,Phone FROM Contact WHERE Id =:user.contactid];
        System.assertEquals('1234567',c1.Phone);
    }
    @isTest static void testupdateProfile(){
        string values='';
        User u=[select id,contactid from User where username ='test1@gmail.com'];
        Contact c = [SELECT Id,Email FROM Contact WHERE Id =:u.contactid];
        c.Email='test123@gmail.com';
        list<Questionnaire.wrapper> wrlist = Questionnaire.getQue(u.Id);
        Test.startTest();
        update c;
            System.runAs(u){
               values =  Questionnaire.updateProfile(wrlist);
            }
    	Test.stopTest();
        Contact c1 = [SELECT Id,Email FROM Contact WHERE Id =:u.contactid];
        System.assert(values.contains('Email'));
    }
}