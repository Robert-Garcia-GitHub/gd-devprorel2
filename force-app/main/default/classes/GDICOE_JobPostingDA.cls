public with sharing class GDICOE_JobPostingDA {
  public static List<GDICOE_Job_List__c> getJobListRecord(String storeName) {
    List<GDICOE_Job_List__c> result;

    List<WebStore> webstore = [
      SELECT Id
      FROM WebStore
      WHERE Name = :storeName
      LIMIT 1
    ];

    if (webstore.isEmpty()) {
      result = new List<GDICOE_Job_List__c>();
    } else {
      result = [
        SELECT Id, Name, Store__c
        FROM GDICOE_Job_List__c
        WHERE Store__r.Id = :webstore.get(0).Id
        LIMIT 1
      ];
    }

    return result;
  }

  public static List<GDICOE_Job_Posting__c> getJobPostingRecords(
    List<GDICOE_Job_List__c> jobList
  ) {
    List<GDICOE_Job_Posting__c> result = null;

    if (jobList != null || !jobList.isEmpty()) {
      result = [
        SELECT Id, Name, Active__c
        FROM GDICOE_Job_Posting__c
        WHERE
          GDICOE_Job_Posting__c.GDICOE_Job_List__r.Id = :joblist.get(0).Id
          AND Active__c = TRUE
      ];
    } else {
      result = new List<GDICOE_Job_Posting__c>();
    }

    return result;
  }

  public static List<GDICOE_Job_Detail__c> getJobDetailRecords(
    List<GDICOE_Job_Posting__c> jobPostings,
    String language
  ) {
    List<GDICOE_Job_Detail__c> result = new List<GDICOE_Job_Detail__c>();

    for (GDICOE_Job_Posting__c jobposting : jobPostings) {
      List<GDICOE_Job_Detail__c> jobdetail = [
        SELECT Id, GDICOE_Job_Posting__r.Id, Name, Location__c
        FROM GDICOE_Job_Detail__c
        WHERE
          GDICOE_Job_Posting__r.Id = :jobposting.Id
          AND Language__c = :language
        LIMIT 1
      ];

      if (jobdetail.isEmpty()) {
        jobdetail = [
          SELECT Id, GDICOE_Job_Posting__r.Id, Name, Location__c
          FROM GDICOE_Job_Detail__c
          WHERE GDICOE_Job_Posting__r.Id = :jobposting.Id
          LIMIT 1
        ];
      }

      if (!jobdetail.isEmpty()) {
        if (
          jobdetail.get(0).Location__c == null ||
          jobdetail.get(0).Location__c == ''
        ) {
          jobdetail.get(0).Location__c = '--';
        }
        result.add(jobdetail.get(0));
      }
    }

    return result;
  }

  public static List<GDICOE_Job_Detail__c> getJobDetailRecord(
    String jobPostingId,
    String displayLanguage
  ) {
    List<GDICOE_Job_Detail__c> result = [
      SELECT GDICOE_Job_Posting__r.Id, Name, Location__c, Description__c, GDICOE_Job_Posting__r.Active__c
      FROM GDICOE_Job_Detail__c
      WHERE GDICOE_Job_Posting__r.Id = :jobPostingId AND Language__c = :displayLanguage
      LIMIT 1
    ];

    if (result.isEmpty()) {
      result = [
        SELECT GDICOE_Job_Posting__r.Id, Name, Location__c, Description__c, GDICOE_Job_Posting__r.Active__c
        FROM GDICOE_Job_Detail__c
        WHERE GDICOE_Job_Posting__r.Id = :jobPostingId 
        LIMIT 1
      ];
    }

    if (!result.isEmpty()) {
      if (
        result.get(0).Location__c == null ||
        result.get(0).Location__c == ''
      ) {
        result.get(0).Location__c = '--';
      }
    }

    return result;
  }

  @AuraEnabled(cacheable=true)
  public static List<GDICOE_Job_Detail__c> getJobPostings(
    String storeName,
    String displayLanguage
  ) {
    List<GDICOE_Job_Detail__c> result = null;

    List<GDICOE_Job_List__c> joblist = getJobListRecord(storeName);
    if (joblist != null && !jobList.isEmpty()) {
      List<GDICOE_Job_Posting__c> jobpostings = getJobPostingRecords(joblist);

      if (!jobpostings.isEmpty()) {
        result = getJobDetailRecords(jobpostings, displayLanguage);
      }
    }

    if (result == null) {
      result = new List<GDICOE_Job_Detail__c>();
    }

    return result;
  }

  @AuraEnabled(cacheable=true)
  public static String getJobDetails(
    String jobPostingId,
    String displayLanguage
  ) {
    String result = '';

    List<GDICOE_Job_Detail__c> jobdetail = getJobDetailRecord(
      jobPostingId,
      displayLanguage
    );

    if (!jobdetail.isEmpty()) {
      result = jobdetail.get(0).GDICOE_Job_Posting__r.Id;
      result += '</>' + jobdetail.get(0).Name;
      result += '</>' + jobdetail.get(0).Location__c;
      result += '</>' + jobdetail.get(0).Description__c;
      result += '</>' + jobdetail.get(0).GDICOE_Job_Posting__r.Active__c;
    }

    return result;
  }

  /*
    @AuraEnabled
    public static String getJobPostingDetail(String jobPostingId) {
        String result;

        List<GDICOE_Job_Posting__c> lookup = [
            SELECT 
                Id,
                Name,
                Location__c,
                Description__c,
                Active__c
            FROM 
                GDICOE_Job_Posting__c
            WHERE 
                Id = :jobPostingId
            LIMIT 1
        ];

        if ( lookup.isEmpty() ) {
            result = '';
        } else {
            result = lookup.get(0).Id;
            result += '</>' + lookup.get(0).Name;
            result += '</>' + lookup.get(0).Location__c;
            result += '</>' + lookup.get(0).Description__c;
            result += '</>' + lookup.get(0).Active__c;
        }

        return result;
    }
    */
}