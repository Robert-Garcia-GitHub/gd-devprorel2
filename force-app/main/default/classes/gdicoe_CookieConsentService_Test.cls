@isTest
public with sharing class gdicoe_CookieConsentService_Test {
  @testSetup
  static void createTestData() {
    gdicoe_CookieConsentCategory__c cookieConsentCategory = gdicoe_CookieConsentTestUtilities.createCookieConsentCategory();
    gdicoe_Cookie__c cookie = gdicoe_CookieConsentTestUtilities.createCookie(cookieConsentCategory.Id);
    gdicoe_CookieConsentTestUtilities.createUser();
    gdicoe_CookieConsentTestUtilities.createStandardUser();
  }

  @isTest
  static void testVerifyBrowserId_guestUser() {
    List<User> users = [SELECT Id FROM User WHERE Username = 'test@cookieconsent.com' LIMIT 1];
    User guestUser = (users.size() == 1) ? users.get(0) : null;

    Test.startTest();

    Boolean result = null;
    System.runAs(guestUser) {
      result = gdicoe_CookieConsentService.verifyBrowserId('123456789');
    }

    Test.stopTest();

    System.assert(!result);
  }

  @isTest
  static void testVerifyBrowserId_standardUser() {
    List<User> users = [SELECT Id FROM User WHERE Username = 'standard@cookieconsent.com' LIMIT 1];
    User standardUser = (users.size() == 1) ? users.get(0) : null;

    Test.startTest();

    Boolean result = null;
    System.runAs(standardUser) {
      result = gdicoe_CookieConsentService.verifyBrowserId('123456789');
    }

    Test.stopTest();

    System.assert(!result);
  }

  @isTest
  static void testGetCookieData() {
    List<User> users = [SELECT Id FROM User WHERE Username = 'standard@cookieconsent.com' LIMIT 1];
    User standardUser = (users.size() == 1) ? users.get(0) : null;

    Test.startTest();

    List<Map<String, Object>> result = new List<Map<String, Object>>();
    System.runAs(standardUser) {
      result = gdicoe_CookieConsentService.getCookieData();
    }

    Test.stopTest();

    System.assert(result.size() == 1);
  }

  @isTest
  static void testVerifyBrowserId_guestUserWithIndividual() {
    Individual individual = gdicoe_CookieConsentTestUtilities.createIndividual();

    List<User> users = [SELECT Id FROM User WHERE Username = 'test@cookieconsent.com' LIMIT 1];
    User guestUser = (users.size() == 1) ? users.get(0) : null;

    Test.startTest();

    Boolean result = null;
    System.runAs(guestUser) {
      result = gdicoe_CookieConsentService.verifyBrowserId('123456789');
    }

    Test.stopTest();

    System.assert(!result);
  }

  @isTest
  static void testVerifyBrowserId_guestUserWithIndividualAndPreferences() {
    List<gdicoe_CookieConsentCategory__c> cookieConsentCategories = [SELECT Id FROM gdicoe_CookieConsentCategory__c LIMIT 1];
    gdicoe_CookieConsentCategory__c cookieConsentCategory = (cookieConsentCategories.size() == 1) ? cookieConsentCategories.get(0) : null;
    Individual individual = gdicoe_CookieConsentTestUtilities.createIndividual();

    Test.startTest();

    List<User> users = [SELECT Id FROM User WHERE Username = 'test@cookieconsent.com' LIMIT 1];
    User guestUser = (users.size() == 1) ? users.get(0) : null;

    List<Map<String, String>> cookiePreferences = new List<Map<String, String>>();

    Map<String, String> preferenceRow = new Map<String, String>();

    preferenceRow.put('authorizationFormId', cookieConsentCategory.Id);
    preferenceRow.put('value', 'true');

    cookiePreferences.add(preferenceRow);

    Boolean createRecords = gdicoe_CookieConsentServiceGuestHelper.createCookieConsentRecords('123456789', cookiePreferences);

    Boolean result = null;
    System.runAs(guestUser) {
      result = gdicoe_CookieConsentService.verifyBrowserId('123456789');
    }

    Test.stopTest();

    System.assert(result, 'consent records were not found');
  }

  @isTest
  static void testGetCookiesToDelete_guestUserWithIndividualAndPreferences() {
    List<gdicoe_CookieConsentCategory__c> cookieConsentCategories = [SELECT Id FROM gdicoe_CookieConsentCategory__c LIMIT 1];
    gdicoe_CookieConsentCategory__c cookieConsentCategory = (cookieConsentCategories.size() == 1) ? cookieConsentCategories.get(0) : null;
    Individual individual = gdicoe_CookieConsentTestUtilities.createIndividual();

    Test.startTest();

    List<User> users = [SELECT Id FROM User WHERE Username = 'test@cookieconsent.com' LIMIT 1];
    User guestUser = (users.size() == 1) ? users.get(0) : null;

    List<Map<String, String>> cookiePreferences = new List<Map<String, String>>();

    Map<String, String> preferenceRow = new Map<String, String>();

    preferenceRow.put('authorizationFormId', cookieConsentCategory.Id);
    preferenceRow.put('value', 'true');

    cookiePreferences.add(preferenceRow);

    Boolean createRecords = gdicoe_CookieConsentServiceGuestHelper.createCookieConsentRecords('123456789', cookiePreferences);

    List<String> cookiesToDelete = new List<String>();
    System.runAs(guestUser) {
      cookiesToDelete = gdicoe_CookieConsentServiceGuestHelper.getCookiesToDelete('123456789');
    }

    Test.stopTest();

    System.assert(cookiesToDelete.size() == 0);
  }
}