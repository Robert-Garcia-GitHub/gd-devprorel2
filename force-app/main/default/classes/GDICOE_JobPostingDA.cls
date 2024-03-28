public with sharing class GDICOE_JobPostingDA {
  public static List<GDICOE_Job_List__c> getJobListForStoreName(String storeName) {
    List<GDICOE_Job_List__c> result = null;

    if ( storeName != null ) {
      try {
        List<WebStore> webstore = [
          SELECT 
            Id
          FROM 
            WebStore
          WHERE Name = :storeName
          LIMIT 1
        ];

        if (webstore.isEmpty()) {
          result = null;
        } else {
          result = [
            SELECT 
              Id, 
              Name, 
              Store__c
            FROM 
              GDICOE_Job_List__c
            WHERE 
              Store__r.Id = :webstore.get(0).Id
            LIMIT 1
          ];
        }
      } catch (Exception e) {
        result = null;
      }
    }

    if ( result == null ) {
      result = new List<GDICOE_Job_List__c>();
    }

    return result;
  }

  public static List<GDICOE_Job_Posting__c> getJobPostingForJobList(
    List<GDICOE_Job_List__c> jobList
  ) {
    List<GDICOE_Job_Posting__c> result = null;

    try {
      if (jobList != null || !jobList.isEmpty()) {
        result = [
          SELECT 
            Id, 
            Active__c, 
            GDICOE_Job_Posting_Template__r.Name,
            GDICOE_Job_Posting__c.GDICOE_Job_List__r.Id
          FROM
            GDICOE_Job_Posting__c
          WHERE
            GDICOE_Job_Posting__c.GDICOE_Job_List__r.Id = :joblist.get(0).Id
            AND Active__c = TRUE
          ORDER BY 
            Name
        ];
      } else {
        result = new List<GDICOE_Job_Posting__c>();
      }
    } catch (Exception e) {
      result = new List<GDICOE_Job_Posting__c>();
    }

    return result;
  }

  public static List<GDICOE_Job_Posting__c> getJobPostingForJobPostingId(string jobPostingId) {
    List<GDICOE_Job_Posting__c> result = null;

    try {
    result = [
      SELECT 
        Id, 
        Active__c, 
        GDICOE_Job_Posting_Template__r.Name,
        GDICOE_Job_Posting__c.GDICOE_Job_List__r.Id
      FROM
        GDICOE_Job_Posting__c
      WHERE
        GDICOE_Job_Posting__c.Id = :jobpostingId
        AND Active__c = TRUE
      ORDER BY 
        Name
      LIMIT 1
    ];
    } catch (Exception e) {
      result = new List<GDICOE_Job_Posting__c>();
    }

    return result;
  }

  public static List<GDICOE_Job_Detail__c> getJobDetailForJobPosting(
    List<GDICOE_Job_Posting__c> jobPostings,
    String displayLanguage
  ) {
    List<GDICOE_Job_Detail__c> result = new List<GDICOE_Job_Detail__c>();

    try {
      for (GDICOE_Job_Posting__c jobposting : jobPostings) {
        List<GDICOE_Job_Detail__c> jobdetail = [
          SELECT 
            Id, 
            Name, 
            Location__c,
            Language__c,
            GDICOE_Job_Posting__r.Id,
            GDICOE_Job_Posting__r.Name
          FROM 
            GDICOE_Job_Detail__c
          WHERE
            GDICOE_Job_Posting__r.Id = :jobposting.Id
            AND Language__c = :displayLanguage
          ORDER BY 
            Name
          LIMIT 1
        ];

        if (jobdetail.isEmpty()) {
          jobdetail = [
            SELECT
            Id, 
            Name, 
            Location__c,
            Language__c,
            GDICOE_Job_Posting__r.Id,
            GDICOE_Job_Posting__r.Name
            FROM 
              GDICOE_Job_Detail__c
            WHERE 
              GDICOE_Job_Posting__r.Id = :jobposting.Id
              ORDER BY
             Name
            LIMIT 1
          ];
        }

        if (jobdetail.isEmpty()) {
          result = null;
        } else {
          result.add(jobdetail.get(0));
        }
      }
    } catch (Exception e) {
      result = new List<GDICOE_Job_Detail__c>();
    }

    return result;
  }

  @AuraEnabled(cacheable=true)
  public static List<GDICOE_Job_Detail__c> getJobPostingListData(
    String storeName,
    String displayLanguage
  ) {
    List<GDICOE_Job_Detail__c> result = null;

    List<GDICOE_Job_List__c> joblist = getJobListForStoreName(storeName);
    if (joblist != null && !jobList.isEmpty()) {
      List<GDICOE_Job_Posting__c> jobpostings = getJobPostingForJobList(joblist);

      if (jobpostings.isEmpty()) {
        result = null;
      } else {
        result = getJobDetailForJobPosting(jobpostings, displayLanguage);
      }
    }

    if (result == null) {
      result = new List<GDICOE_Job_Detail__c>();
    } else {
      result.sort();
    }
    
    return result;
  }

  @AuraEnabled(cacheable=true)
  public static String getAssetUrlForTitle(String title) {
    String result = '';
    try {
      result = [
        SELECT 
          Data__c
        FROM 
          GDICOE_Job_Posting_Asset__c 
        WHERE 
          Name = :title 
        LIMIT 1].Data__c ;     
      } catch (Exception e) {
        result = '';
    }
    return result;
  }

  @AuraEnabled(cacheable=true)
  public static String getAssetDataForTitle(String title) {
    String result = '';
    try {
      List<ContentVersion> content = [
        SELECT 
          FileType,
          VersionData 
        FROM 
          ContentVersion 
        WHERE 
          Title = :title 
          AND IsLatest = true 
        LIMIT 1] ;
        
        if ( content.isEmpty() ) {
          result = '';
        } else {
          result = 'data:image/' + content.get(0).FileType.toLowerCase() + ';base64,' + EncodingUtil.base64Encode(content.get(0).VersionData);
        }
      } catch (Exception e) {
        result = '';
    }
    return result;
  }

  @AuraEnabled(cacheable=true)
  public static GDICOE_Job_Posting_Template__c getJobPostingTemplateForJobDetailId(String jobDetailId) {
    GDICOE_Job_Posting_Template__c result = null;

    try {
      List<GDICOE_Job_Detail__c> jobDetail = [
        SELECT 
          Id,
          Name,
          GDICOE_Job_Posting__r.Id
        FROM 
          GDICOE_Job_Detail__c
        WHERE
          Id = :jobDetailId
        LIMIT 1
      ];

      if ( jobDetail.isEmpty() ) {
        result = null;
      } else {
        Id jobPostingId = jobDetail.get(0).GDICOE_Job_Posting__r.Id;

        List<GDICOE_Job_Posting__c> jobPosting = [
          SELECT 
            Id,
            Name,
            GDICOE_Job_Posting_Template__r.Id
          FROM 
            GDICOE_Job_Posting__c
          WHERE
            Id = :jobPostingId
          LIMIT 1
        ];
  
        if ( jobPosting.isEmpty() ) {
          result = null;
        } else {
          Id templateId = jobPosting.get(0).GDICOE_Job_Posting_Template__r.Id;
          List<GDICOE_Job_Posting_Template__c> template = [
            SELECT
              Id,
              Name,
              HtmlText__c,
              CssText__c,
              ApplyLink__c
            FROM 
              GDICOE_Job_Posting_Template__c
            WHERE
              Id = :templateId
            LIMIT 1
          ];

          if ( template.isEmpty() ) {
            result = null;
          } else {
            result = template.get(0);
          }
        }
      }
    } 
    catch (Exception e) {
      result = null;
    }

    if ( result == null ) {
      result = new GDICOE_Job_Posting_Template__c();
      result.HtmlText__c = '';
      result.CssText__c = '';
      result.ApplyLink__c = '';
    }

    return result;
  }

  @AuraEnabled(cacheable=true)
  public static GDICOE_Job_Detail__c getJobDetailDataForJobDetailId(
    String jobDetailId,
    String displayLanguage
  ) {
    GDICOE_Job_Detail__c result = null;
    
    if (jobDetailId != null && jobDetailId != '') {
      try {
        List<GDICOE_Job_Detail__c> jobdetail = [
          SELECT 
            Id,  
            Advantages__c, 
            Assets__c, 
            Description__c, 
            Footer__c, 
            Header__c, 
            Keywords__c, 
            Language__c,  
            Location__c, 
            Name, 
            Profile__c, 
            Responsibilities__c
          FROM 
            GDICOE_Job_Detail__c
          WHERE
            Id = :jobDetailId
            AND Language__c = :displayLanguage
          ORDER BY 
            Name
          LIMIT 1
        ];

        if (jobdetail.isEmpty()) {
          jobdetail = [
            SELECT
              Id,  
              Advantages__c, 
              Assets__c, 
              Description__c, 
              Footer__c, 
              Header__c,  
              Keywords__c, 
              Language__c,  
              Location__c, 
              Name, 
              Profile__c, 
              Responsibilities__c
            FROM 
              GDICOE_Job_Detail__c
            WHERE 
              Id = :jobDetailId
            ORDER BY
              Name
            LIMIT 1
          ];
        }

        if (jobdetail.isEmpty()) {
          result = null;
        } else {
          result = jobdetail.get(0);
        }
      
      } catch (Exception e) {
        result = null;
      }
    }

    if ( result == null ) {
      result = new GDICOE_Job_Detail__c();
      result.Id = null;
      result.Advantages__c = '';
      result.Assets__c = '';
      result.Description__c = '';
      result.Footer__c = '';
      result.Header__c = '';
      result.Keywords__c = '';
      result.Language__c = '';
      result.Location__c = '';
      result.Name = '';
      result.Profile__c = '';
      result.Responsibilities__c = '';
    }

    return result; 
  }

  @AuraEnabled(cacheable=true)
  public static String getJobPostingTranslationDataAsJSON(
    String displayLanguage
  ) {
    Map<string, string> result = new Map<String, String>();

    List<GDICOE_Job_Posting_Translation__c> translations = [
      SELECT 
        Id,
        Name,
        Language__c,
        Asset__c,
        GDICOE_Job_Posting_Field__r.Name
      FROM 
        GDICOE_Job_Posting_Translation__c
      WHERE
        Language__c = :displayLanguage
    ];

    if ( !translations.isEmpty() ) {
      for ( GDICOE_Job_Posting_Translation__c translation : translations ) {
        if ( translation.Asset__c ) {
          result.put('/' + translation.Name, getAssetUrlForTitle(translation.Name));
        } else {
          result.put(translation.GDICOE_Job_Posting_Field__r.Name, translation.Name);
        }
      }
    }

    return JSON.serialize(result);
  }

  @AuraEnabled(cacheable=true)
  public static String getJobPostingTemplateDataAsJSON(
    String jobDetailId
  ) {
    Map<String,String> result = new Map<String,String>();

    GDICOE_Job_Posting_Template__c jobtemplate = getJobPostingTemplateForJobDetailId(jobDetailId);

    result.put('Id',jobtemplate.Id);
    result.put('HtmlText__c',jobtemplate.HtmlText__c);
    result.put('CssText__c',jobtemplate.CssText__c);
    result.put('ApplyLink__c',jobtemplate.ApplyLink__c);

    return JSON.serialize(result);
  }

  @AuraEnabled(cacheable=true)
  public static String getJobDetailDataAsJSON(
    String jobDetailId,
    String displayLanguage
  ) {
    Map<String,String> result = new Map<String,String>();

    GDICOE_Job_Detail__c jobdetail = getJobDetailDataForJobDetailId(jobDetailId, displayLanguage);

    result.put('Id',( jobdetail.Id == null ? '' : jobdetail.Id));
    result.put('Advantages__c',jobdetail.Advantages__c);
    result.put('Assets__c',jobdetail.Assets__c);
    result.put('Description__c',jobdetail.Description__c);
    result.put('Footer__c',jobdetail.Footer__c);
    result.put('Header__c',jobdetail.Header__c);
    result.put('Keywords__c',jobdetail.Keywords__c);
    result.put('Language__c',jobdetail.Language__c);
    result.put('Location__c',jobdetail.Location__c);
    result.put('Name',jobdetail.Name);
    result.put('Profile__c',jobdetail.Profile__c);
    result.put('Responsibilities__c',jobdetail.Responsibilities__c);

    return JSON.serialize(result);
  }

  @AuraEnabled(cacheable=true)
  public static String getJobDetailPayloadAsJSON(
    String jobPostingId,
    String displayLanguage
  ) {
    Map<String,String> result = new Map<String,String>();
    String empty = JSON.serialize(result);

    List<GDICOE_Job_Posting__c> jobPostings = getJobPostingForJobPostingId(jobPostingId);
    List<GDICOE_Job_Detail__c> jobDetails = getJobDetailForJobPosting(jobPostings, displayLanguage);

    if ( jobDetails.isEmpty() ) {
      result.put('field', empty);
      result.put('template', empty);
      result.put('translation', empty);
    } else {
      String jobDetailId = jobDetails.get(0).Id;

      result.put('field', getJobDetailDataAsJSON(jobDetailId, displayLanguage));
      result.put('template', getJobPostingTemplateDataAsJSON(jobDetailId));
      result.put('translation', getJobPostingTranslationDataAsJSON(displayLanguage));  
    }

    return JSON.serialize(result);
  }
}
