@isTest
private class RestApiTest {
    
    public static User TEST_USER;
    
    public static Contact TEST_CONTACT;
    
    //@TODO: implement clean setupTest
    private static void setupTest() {
		Profile p = [SELECT Id FROM Profile WHERE Name='Standardbenutzer']; 
        System.debug(p);
        User u = new User(Alias='standt', Email='standard.user@example.org', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standard.user@test.sfdx.mfm');
        System.debug(u);
        TEST_USER = u;
        
		System.runAs(TEST_USER) {        
			Contact c = new Contact();
			c.lastname = 'last name';
            Insert c;
			TEST_CONTACT = c;

		}
        System.debug(TEST_CONTACT);
        
    }
    private static testMethod void restShouldReturnNotFoundAction() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = 'unknown';
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        RestApi.doGet();
        
        System.assertEquals(RestContext.response.statusCode, 400);
    }
    
    private static testMethod void restShouldReturnEmptyPostResponce() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = 'unknown';
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;
        
        RestApi.doPost();
        
        System.assertEquals(RestContext.response.statusCode, 400);
    }
    
    private static testMethod void restShouldReturnResponce() {
        setupTest();
        System.runAs(TEST_USER) {        
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            
            req.requestURI = '/contacts/'+ TEST_CONTACT.id;
            req.httpMethod = 'GET';
            
            RestContext.request = req;
            RestContext.response= res;
            RestApi.doGet();
                        
        }
        System.assertEquals(200, RestContext.response.statusCode);
    }
    
}