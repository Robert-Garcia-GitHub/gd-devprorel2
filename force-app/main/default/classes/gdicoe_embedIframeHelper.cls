public with sharing class gdicoe_embedIframeHelper {
  public gdicoe_embedIframeHelper() {
  }

  @AuraEnabled
  public static String getUserId() {
    // get user's ID
    return UserInfo.getUserId();
  }

  @AuraEnabled
  public static String getUserEmail() {
    // get user's email address
    return UserInfo.getUserEmail();
  }

  @AuraEnabled
  public static String getUserName() {
    // get user's username
    return UserInfo.getUserName();
  }

  @AuraEnabled
  public static String getName() {
    // get user's name
    return UserInfo.getName();
  }

  @AuraEnabled
  public static String getAccountId() {
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

      result = u.Contact.AccountId;
    } catch (Exception e) {
      result = '';
    }

    return result;
  }

  @AuraEnabled
  public static String getAccountExternalId() {
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

      result = a.Account_External_ID__c;
    } catch (Exception e) {
      result = '';
    }

    return result;
  }

  @AuraEnabled
  public static String getUserDataDelimited() {
    String result =
      GetUserId() +
      '\t' +
      GetName() +
      '\t' +
      GetUserName() +
      '\t' +
      GetUserEmail() +
      '\t' +
      getAccountId() +
      '\t' +
      getAccountExternalId();

    return result;
  }
}
