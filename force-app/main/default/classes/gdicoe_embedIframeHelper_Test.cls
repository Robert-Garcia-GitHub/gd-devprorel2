@isTest
private class gdicoe_embedIframeHelper_Test {
    @isTest static void test_getUserId() {
        // get the value returned by the function
        String value = gdicoe_embedIframeHelper.getUserId();
        // compare that value with the expected value
        System.assertEquals(UserInfo.getUserId(), value);
    }
    
    @isTest static void test_getUserEmail() {
        // get the value returned by the function
        String value = gdicoe_embedIframeHelper.getUserEmail();
        // compare that value with the expected value
        System.assertEquals(UserInfo.getUserEmail(), value);
    }
    
    @isTest static void test_getUserName() {
        // get the value returned by the function
        String value = gdicoe_embedIframeHelper.getUserName();
        // compare that value with the expected value
        System.assertEquals(UserInfo.getUserName(), value);
    }
    
    @isTest static void test_getName() {
        // get the value returned by the function
        String value = gdicoe_embedIframeHelper.getName();
        // compare that value with the expected value
        System.assertEquals(UserInfo.getName(), value);
    }
    
    static String expected_getAccountId() {
        // get user's account ID (not the account external ID, but the Salesforce account ID)
        String userId = UserInfo.getUserId();
        String result = '';
        try {
            // with the given user ID, try to lookup its account ID
            User u = [
                SELECT Id, Contact.AccountId
                FROM User
                WHERE Id = :userId
                LIMIT 1
            ];
            
            if ( u == null || u.Contact == null || u.Contact.AccountId == null) {
                result = '';
            } else {
                result = u.Contact.AccountId;
            } 
        } catch (Exception e) {
            result = '';
        }
        
        return result;
    }
    
    @isTest static void test_getAccountId() {
        // get the value returned by the function
        String value = gdicoe_embedIframeHelper.getAccountId();
        // compare that value with the expected value
        System.assertEquals(expected_getAccountId(), value);
    }
    
    static String expected_getAccountExternalId() {
        // get user's account external ID
        String userId = UserInfo.getUserId();
        String result = '';
        try {
            // with the given user ID, try to find its account ID
            User u = [
                SELECT Id, Contact.AccountId
                FROM User
                WHERE Id = :userId
                LIMIT 1
            ];
            String accountId = u.Contact.AccountId;
            // then, with the account ID, look up the account external ID
            Account a = [
                SELECT Id, Account_External_ID__c
                FROM Account
                WHERE Id = :accountId
                LIMIT 1
            ];
            
            if ( a == null || a.Account_External_ID__c == null) {
                result = '';
            } else {
                result = a.Account_External_ID__c;
            }    
        } catch (Exception e) {
            result = '';
        }
        
        return result;
    }
    
    @isTest static void test_getAccountExternalId() {
        // get the value returned by the function
        String value = gdicoe_embedIframeHelper.getAccountId();
        // compare that value with the expected value
        System.assertEquals(expected_getAccountExternalId(), value);
    }
    
    static String expected_getUserDataDelimited() {
        String result =
            UserInfo.GetUserId() +
            '\t' +
            UserInfo.GetName() +
            '\t' +
            UserInfo.GetUserName() +
            '\t' +
            UserInfo.GetUserEmail() +
            '\t' +
            expected_getAccountId() +
            '\t' +
            expected_getAccountExternalId();
        
        return result;
    }
    
    @isTest static void test_getUserDataDelimited() {
        // get the value returned by the function
        String value = gdicoe_embedIframeHelper.getUserDataDelimited();
        // compare that value with the expected value
        System.assertEquals(expected_getUserDataDelimited(), value);
    }
}