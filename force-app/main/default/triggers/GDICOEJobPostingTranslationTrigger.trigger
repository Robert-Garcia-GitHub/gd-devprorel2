trigger GDICOEJobPostingTranslationTrigger on GDICOE_Job_Posting_Translation__c (before insert, before update) {    
    for ( GDICOE_Job_Posting_Translation__c translation : Trigger.new ) {
        if ( translation.Asset__c ) {
            List<GDICOE_Job_Posting_Asset__c> existing = [
            SELECT
                Id,
                Name
            FROM 
                GDICOE_Job_Posting_Asset__c
            WHERE
                Name = :translation.Name
            LIMIT 1
            ];
        
            if ( existing.isEmpty() ) {
                GDICOE_Job_Posting_Asset__c asset = new GDICOE_Job_Posting_Asset__c();
                asset.Name = translation.Name;
                insert asset;
            }
        }
    }
}