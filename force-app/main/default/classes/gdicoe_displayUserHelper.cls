public with sharing class gdicoe_displayUserHelper {
    public gdicoe_displayUserHelper() {

    }

    @AuraEnabled
    public static String getUserId() {  
        return UserInfo.getUserId();
    }

    @AuraEnabled
    public static String getUserEmail() {
        return UserInfo.getUserEmail();
    }

    @AuraEnabled
    public static String getUserName() {
        return UserInfo.getUserName();
    }

    @AuraEnabled
    public static String getName() {
        return UserInfo.getName();
    }

    @AuraEnabled
    public static String getAccountId(){
        String userId = UserInfo.getUserId();
        String result = '';
        try {
        	User u = [SELECT Id, Contact.AccountId FROM User WHERE Id =: userId LIMIT 1];
            result = u.Contact.AccountId;
        } catch (Exception e) {
            result = '';
        }
        return result;
    }

    @AuraEnabled
    public static String getAccountExternalId(){
        String userId = UserInfo.getUserId();
        String result = '';
        try {
        	User u = [SELECT Id, Contact.AccountId FROM User WHERE Id =: userId LIMIT 1];
        	String accountId = u.Contact.AccountId;
        	Account a = [ SELECT Id, Account_External_ID__c FROM Account WHERE Id = :accountId LIMIT 1];
        	result = a.Account_External_ID__c;
        } catch (Exception e) {
            result = '';
        }
        return result;
    }
}