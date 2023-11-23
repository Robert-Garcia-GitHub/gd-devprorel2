public without sharing class gdicoe_CookieConsentServiceGuestHelper {
  /**
   * getIndividualByUserID will get the logged in userId and check to see if an individual has been created
   * @param browserId - the unique browser Id passed from the community
   */
  public static Individual getIndividualByBrowserId(String browserId) {
    List<Individual> individuals = [
      SELECT Id, BrowserId__c
      FROM Individual
      WHERE BrowserId__c = :browserId
      LIMIT 1
    ];
    Individual individual = (individuals.size() == 1)
      ? individuals.get(0)
      : null;
    return individual;
  }

  /**
   * @description - createAuthorizationFormConsentRecords is used to create the consent records that are associated to a positive agreement to cookies.
   * @param individualId - the individualId associated to the user that is accepting the terms
   * @param relatedAuthorizationFormNames - the list of authorization form records that is being used to create the consent records
   */
  public static List<gdicoe_CookieConsent__c> createAuthorizationFormConsentRecords(
    Id individualId,
    List<Map<String, String>> cookiePreferences
  ) {
    List<gdicoe_CookieConsent__c> authorizationFormConsentRecords = new List<gdicoe_CookieConsent__c>();
    for (Map<String, String> cookiePreference : cookiePreferences) {
      List<gdicoe_CookieConsentCategory__c> cookieConsentCategories = [
        SELECT Id, Name
        FROM gdicoe_CookieConsentCategory__c
        WHERE Id = :cookiePreference.get('authorizationFormId')
        //WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      gdicoe_CookieConsentCategory__c cookieConsentCategory = (cookieConsentCategories.size() ==
        1)
        ? cookieConsentCategories.get(0)
        : null;
      gdicoe_CookieConsent__c newAuthorizationFormConsentRecord = new gdicoe_CookieConsent__c();
      newAuthorizationFormConsentRecord.Name = cookieConsentCategory.Name;
      newAuthorizationFormConsentRecord.gdicoe_CookieConsentCategory__c = cookieConsentCategory.Id;
      newAuthorizationFormConsentRecord.ConsentCapturedSource__c = 'Salesforce Community';
      newAuthorizationFormConsentRecord.ConsentCapturedSourceType__c = 'Web';
      newAuthorizationFormConsentRecord.ConsentGiverId__c = individualId;
      if (cookiePreference.get('value') == 'true') {
        newAuthorizationFormConsentRecord.Status__c = 'Agreed';
      } else if (cookiePreference.get('value') == 'false') {
        newAuthorizationFormConsentRecord.Status__c = 'Declined';
      }
      authorizationFormConsentRecords.add(newAuthorizationFormConsentRecord);
    }
    insert authorizationFormConsentRecords;
    return authorizationFormConsentRecords;
    /*
    SObjectAccessDecision sanitisedRecords = Security.stripInaccessible(AccessType.CREATABLE, authorizationFormConsentRecords);
    insert sanitisedRecords.getRecords();
    return sanitisedRecords.getRecords();
    */
  }

  /**
   * verifyCookieConsentGranted is called  by verifyCookieConsent if an Individual has been matched to the browserId
   * It gets a list of the available cookie consent definitions, the related authorization form names and then queries a
   * list of valid authorization form consent records that fit those definitions.
   * @param individualId - the individual record associated to the browserId
   */
  public static Boolean verifyCookieConsentGranted(Id individualId) {
    List<gdicoe_CookieConsentCategory__c> cookieConsentCategories = getCookieConsentCategories();
    Set<Id> authFormIds = (new Map<Id, SObject>(cookieConsentCategories))
      .keySet();
    List<gdicoe_CookieConsent__c> authorizationFormConsents = [
      SELECT Id
      FROM gdicoe_CookieConsent__c
      WHERE
        gdicoe_CookieConsentCategory__c IN :authFormIds
        AND ConsentGiverId__c = :individualId
      //WITH SECURITY_ENFORCED
    ];
    if (authorizationFormConsents.size() >= cookieConsentCategories.size()) {
      return true;
    }
    return false;
  }

  /**
   * createIndividualRecord is used to create an individual for a logged in user or browserId
   * @param userId - the userId of the logged in user
   * @param browserId - the unique browser Id passed from the community
   */
  public static Id createIndividualRecord(Id userId, String browserId) {
    List<Individual> newIndividuals = new List<Individual>();
    Individual newIndividual = new Individual(
      LastName = browserId,
      BrowserId__c = browserId
    );
    newIndividuals.add(newIndividual);
    /*
    SObjectAccessDecision sanitisedRecords = Security.stripInaccessible(AccessType.CREATABLE, newIndividuals);
    insert sanitisedRecords.getRecords();
    return sanitisedRecords.getRecords()[0].Id;
    */
    insert newIndividual;
    return newIndividual.Id;
  }

  /**
   * @description - Reusable SOQL Queries Cookie Records
   */
  public static List<gdicoe_CookieConsentCategory__c> getCookieConsentCategories() {
    List<gdicoe_CookieConsentCategory__c> cookieConsentCategories = [
      SELECT
        DefaultValue__c,
        Description__c,
        Mandatory__c,
        AdditionalInformation__c,
        Id,
        Name
      FROM gdicoe_CookieConsentCategory__c
      ORDER BY Name
    ];
    return cookieConsentCategories;
  }

  /**
   * @description - Reusable SOQL Queries Cookie Records
   */
  public static List<gdicoe_CookieConsentCategory__c> getCookieConsentCategoriesLang(
    String htmlLang
  ) {
    List<gdicoe_CookieConsentCategory__c> result = new List<gdicoe_CookieConsentCategory__c>();
    String key = '';

    // get translations
    List<gdicoe_CookieConsentCategoryTranslation__c> translations = [
      SELECT
        AdditionalInformation__c,
        gdicoe_CookieConsentCategory__r.Id,
        gdicoe_CookieConsentCategory__r.Name,
        Name,
        Name__c,
        Language__c,
        Description__c
      FROM gdicoe_CookieConsentCategoryTranslation__c
      WHERE Language__c = :htmlLang
    ];

    // build a translation map so we can look them up
    Map<String, gdicoe_CookieConsentCategoryTranslation__c> translationMap = new Map<String, gdicoe_CookieConsentCategoryTranslation__c>();
    for (gdicoe_CookieConsentCategoryTranslation__c translation : translations) {
      // this is the key used to access the translation
      key = translation.gdicoe_CookieConsentCategory__r.Name + ' ' + htmlLang;
      System.Debug('key for map = ' + key);
      // add it in only once
      if (!translationMap.containsKey(key)) {
        translationMap.put(key, translation);
      }
    }

    // get cookie consent categories
    List<gdicoe_CookieConsentCategory__c> cookieConsentCategories = [
      SELECT
        DefaultValue__c,
        Description__c,
        Mandatory__c,
        AdditionalInformation__c,
        Id,
        Name
      FROM gdicoe_CookieConsentCategory__c
      ORDER BY Name
    ];

    // for each cookie consent category, try to translate
    for (
      gdicoe_CookieConsentCategory__c cookieConsentCategory : cookieConsentCategories
    ) {
      // make a copy of the cookie consent category to translate
      gdicoe_CookieConsentCategory__c translated = new gdicoe_CookieConsentCategory__c(
        DefaultValue__c = cookieConsentCategory.DefaultValue__c,
        Description__c = cookieConsentCategory.Description__c,
        Mandatory__c = cookieConsentCategory.Mandatory__c,
        AdditionalInformation__c = cookieConsentCategory.AdditionalInformation__c,
        Id = cookieConsentCategory.Id,
        Name = cookieConsentCategory.Name
      );

      // check if a translation exists
      key = translated.Name + ' ' + htmlLang;
      System.Debug('key for lookup = ' + key);
      if (translationMap.containsKey(key)) {
        gdicoe_CookieConsentCategoryTranslation__c mapValue = translationMap.get(Key); 
        translated.Name = mapValue.Name__c;
        translated.Description__c = mapValue.Description__c;
        translated.AdditionalInformation__c = mapValue.AdditionalInformation__c;
      }

      // add the cookie to the returned result
      result.add(translated);
    }

    return result;
  }

  public static List<gdicoe_Cookie__c> getRelatedCookies(Id cookieConsentCategoryId) {
    List<gdicoe_Cookie__c> relatedCookies = [
      SELECT Description__c, Id, Name
      FROM gdicoe_Cookie__c
      WHERE gdicoe_CookieConsentCategory__c = :cookieConsentCategoryId
    ];
    return relatedCookies;
  }

  public static List<gdicoe_Cookie__c> getRelatedCookiesLang(
    Id cookieConsentCategoryId,
    string htmlLang
  ) {
    List<gdicoe_Cookie__c> result = new List<gdicoe_Cookie__c>();
    String key = '';

    // get translations
    List<gdicoe_CookieTranslation__c> translations = [
      SELECT gdicoe_Cookie__r.Id, gdicoe_Cookie__r.Name, Name, Language__c, Description__c
      FROM gdicoe_CookieTranslation__c
      WHERE Language__c = :htmlLang
    ];

    // build a translation map so we can look them up
    Map<String, gdicoe_CookieTranslation__c> translationMap = new Map<String, gdicoe_CookieTranslation__c>();
    for (gdicoe_CookieTranslation__c translation : translations) {
      // this is the key used to access the translation
      key = translation.gdicoe_Cookie__r.Name + ' ' + htmlLang;

      // add it in only once
      if (!translationMap.containsKey(key)) {
        translationMap.put(key, translation);
      }
    }

    // get related cookies
    List<gdicoe_Cookie__c> relatedCookies = [
      SELECT Description__c, Id, Name
      FROM gdicoe_Cookie__c
      WHERE gdicoe_CookieConsentCategory__c = :cookieConsentCategoryId
    ];

    // for each related cookie, try to translate
    for (gdicoe_Cookie__c cookie : relatedCookies) {
      // make a copy of the cookie to translate
      gdicoe_Cookie__c translated = new gdicoe_Cookie__c(
        Id = cookie.Id,
        Name = cookie.Name,
        Description__c = cookie.Description__c
      );

      // check if a translation exists
      key = translated.Name + ' ' + htmlLang;
      if (translationMap.containsKey(key)) {
        translated.Description__c = translationMap.get(Key).Description__c;
      }

      // add the cookie to the returned result
      result.add(translated);
    }

    return result;
  }

  /**
   * getIndividualByUserID will get the logged in userId and check to see if an individual has been created
   * @param userId - the userId of the logged in user
   */
  public static User getLoggedInUserDetails(Id userId) {
    List<User> users = [
      SELECT FirstName, LastName, IndividualId
      FROM User
      WHERE Id = :userId
      LIMIT 1
    ];
    User user = (users.size() == 1) ? users.get(0) : null;
    return user;
  }

  /**
   * @description - Get cookies from the user if they've been rejected by the person accessing the community.
   * @param browserId - the unique browser Id passed from the community
   * @return List<String> of Cookies
   */

  @AuraEnabled
  public static List<String> getCookiesToDelete(String browserId) {
    Set<Id> categoryIds = new Set<Id>();
    for (gdicoe_CookieConsent__c consent : [
      SELECT gdicoe_CookieConsentCategory__c
      FROM gdicoe_CookieConsent__c
      WHERE
        ConsentGiverId__c IN (
          SELECT Id
          FROM Individual
          WHERE BrowserId__c = :browserId
        )
        AND Status__c = 'Declined'
    ]) {
      categoryIds.add(consent.gdicoe_CookieConsentCategory__c);
    }

    List<String> cookieNames = new List<String>();
    for (gdicoe_Cookie__c cookie : [
      SELECT Id, Name
      FROM gdicoe_Cookie__c
      WHERE gdicoe_CookieConsentCategory__c IN :categoryIds
    ]) {
      cookieNames.add(cookie.Name);
    }
    return cookieNames;
  }

  /**
   * createCookieConsentRecords is used to confirm authorization for cookie consent against the browserId
   * @param browserId - the unique browser Id passed from the community
   */
  @AuraEnabled
  public static boolean createCookieConsentRecords(
    String browserId,
    List<Map<String, String>> cookiePreferences
  ) {
    Individual individual = gdicoe_CookieConsentServiceGuestHelper.getIndividualByBrowserId(
      browserId
    );
    List<gdicoe_CookieConsent__c> createdConsentRecords = gdicoe_CookieConsentServiceGuestHelper.createAuthorizationFormConsentRecords(
      individual.Id,
      cookiePreferences
    );
    if (createdConsentRecords != null) {
      return true;
    }
    return false;
  }
}
