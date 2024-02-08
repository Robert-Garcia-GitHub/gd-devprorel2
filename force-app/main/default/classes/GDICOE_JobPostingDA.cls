public with sharing class GDICOE_JobPostingDA {
    @AuraEnabled(cacheable=true)
    public static List<GDICOE_JobPosting__c> getJobPostingList(String storeName) {
        List<GDICOE_JobPosting__c> result;

        List<WebStore> webstore = [
            SELECT 
                Id
            FROM 
                WebStore
            WHERE 
                Name = :storeName
        ];

        if ( webstore.isEmpty() ) {
            result = null;
        } else {
            result = [
                SELECT 
                    Id,
                    Name,
                    Location__c
                FROM
                    GDICOE_JobPosting__c
                WHERE
                    Active__c = true
                    AND Store__r.Id = :webstore.get(0).Id
                ORDER BY
                    Name            
            ];
          }

        return result;
    }

    @AuraEnabled
    public static String getJobPostingDetail(String jobPostingId) {
        String result;

        List<GDICOE_JobPosting__c> lookup = [
            SELECT 
                Id,
                Name,
                Location__c,
                Description__c,
                Active__c
            FROM 
                GDICOE_JobPosting__c
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
}