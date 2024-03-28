trigger GDICOEJobPostingAssetTrigger on GDICOE_Job_Posting_Asset__c (before insert, before update) {
    for ( GDICOE_Job_Posting_Asset__c asset : Trigger.new ) {
        asset.Data__c = GDICOE_JobPostingDA.getAssetDataForTitle(asset.Name);
    }
}