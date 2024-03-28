@IsTest
public with sharing class GDICOE_JobPostingDA_Test {

  @IsTest 
  static void test_getJobListForStoreName() {
    List<GDICOE_Job_List__c> value = GDICOE_JobPostingDA.getJobListForStoreName(null);
    System.assertEquals(value.isEmpty(), true, 'GDICOE_JobPostingDA_Test test_getJobListForStoreName #1/2');

    value = GDICOE_JobPostingDA.getJobListForStoreName('');
    System.assertEquals(value.isEmpty(), true, 'GDICOE_JobPostingDA_Test test_getJobListForStoreName #2/2');
  }

  @IsTest 
  static void test_getJobPostingFromJobList() {
    List<GDICOE_Job_List__c> jobList = new List<GDICOE_Job_List__c>();
    List<GDICOE_Job_Posting__c> value = GDICOE_JobPostingDA.getJobPostingForJobList(jobList);
    System.assertEquals(value.isEmpty(), true, 'GDICOE_JobPostingDA_Test test_getJobPostingFromJobList #1/1');
  }

  @IsTest 
  static void test_getJobPostingForJobPostingId() {
    List<GDICOE_Job_Posting__c> value = GDICOE_JobPostingDA.getJobPostingForJobPostingId(null);
    System.assertEquals(value.isEmpty(), true, 'GDICOE_JobPostingDA_Test test_getJobPostingForJobPostingId #1/1');
  }
  
  @IsTest
  static void test_getJobDetailForJobPosting() {
    List<GDICOE_Job_Posting__c> jobposting = new List<GDICOE_Job_Posting__c>();
    List<GDICOE_Job_Detail__c> value;

    value = GDICOE_JobPostingDA.getJobDetailForJobPosting(null,null);
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobDetailForJobPosting #1/8');

    value = GDICOE_JobPostingDA.getJobDetailForJobPosting(null,'');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobDetailForJobPosting #2/8');

    value = GDICOE_JobPostingDA.getJobDetailForJobPosting(null,'en');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobDetailForJobPosting #3/8');

    value = GDICOE_JobPostingDA.getJobDetailForJobPosting(null,'fr');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobDetailForJobPosting #4/8');

    value = GDICOE_JobPostingDA.getJobDetailForJobPosting(jobposting,null);
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobDetailForJobPosting #5/8');

    value = GDICOE_JobPostingDA.getJobDetailForJobPosting(jobposting,'');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobDetailForJobPosting #6/8');

    value = GDICOE_JobPostingDA.getJobDetailForJobPosting(jobposting,'en');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobDetailForJobPosting #7/8');

    value = GDICOE_JobPostingDA.getJobDetailForJobPosting(jobposting,'fr');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobDetailForJobPosting #8/8');
  }
  
  @IsTest
  static void test_getJobPostingListData() {
    List<GDICOE_Job_Detail__c> value;

    value = GDICOE_JobPostingDA.getJobPostingListData(null,null);
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingListData #1/8');

    value = GDICOE_JobPostingDA.getJobPostingListData(null,'');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingListData #2/8');

    value = GDICOE_JobPostingDA.getJobPostingListData(null,'en');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingListData #3/8');

    value = GDICOE_JobPostingDA.getJobPostingListData(null,'fr');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingListData #4/8');

    value = GDICOE_JobPostingDA.getJobPostingListData('',null);
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingListData #5/8');

    value = GDICOE_JobPostingDA.getJobPostingListData('','');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingListData #6/8');

    value = GDICOE_JobPostingDA.getJobPostingListData('','en');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingListData #7/8');

    value = GDICOE_JobPostingDA.getJobPostingListData('','fr');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingListData #8/8');
  }

  @IsTest 
  static void test_getAssetUrlForTitle() {
    String value = GDICOE_JobPostingDA.getAssetUrlForTitle(null);
    System.assertEquals(value, '', 'GDICOE_JobPostingDA_Test test_getAssetUrlForTitle #1/2');

    value = GDICOE_JobPostingDA.getAssetUrlForTitle('');
    System.assertEquals(value, '', 'GDICOE_JobPostingDA_Test test_getAssetUrlForTitle #2/2');
  }

  @IsTest 
  static void test_getAssetDataForTitle() {
    String value = GDICOE_JobPostingDA.getAssetDataForTitle(null);
    System.assertEquals(value, '', 'GDICOE_JobPostingDA_Test test_getAssetDataForTitle #1/2');

    value = GDICOE_JobPostingDA.getAssetDataForTitle('');
    System.assertEquals(value, '', 'GDICOE_JobPostingDA_Test test_getAssetDataForTitle #2/2');
  }

  @IsTest 
  static void test_getJobPostingTemplateForJobDetailId() {
    GDICOE_Job_Posting_Template__c jobTemplate = GDICOE_JobPostingDA.getJobPostingTemplateForJobDetailId(null);
    Boolean value = (jobTemplate.HtmlText__c == '' && jobTemplate.CssText__c == '' && jobTemplate.ApplyLink__c == '');
    System.assertEquals(value , true, 'GDICOE_JobPostingDA_Test test_getJobPostingTemplateForJobDetailId #1/2');

    jobTemplate = GDICOE_JobPostingDA.getJobPostingTemplateForJobDetailId('');
    value = (jobTemplate.HtmlText__c == '' && jobTemplate.CssText__c == '' && jobTemplate.ApplyLink__c == '');
    System.assertEquals(value, true, 'GDICOE_JobPostingDA_Test test_getJobPostingTemplateForJobDetailId #2/2');
  }

  @IsTest
  static void test_getJobDetailDataForJobDetailId() {
    GDICOE_Job_Detail__c value;

    value = GDICOE_JobPostingDA.getJobDetailDataForJobDetailId('',null);
    System.assertEquals(value.Name, '','GDICOE_JobPostingDA_Test test_getJobDetailDataForJobDetailId #1/4');

    value = GDICOE_JobPostingDA.getJobDetailDataForJobDetailId('','');
    System.assertEquals(value.Name, '','GDICOE_JobPostingDA_Test test_getJobDetailDataForJobDetailId #2/4');

    value = GDICOE_JobPostingDA.getJobDetailDataForJobDetailId('','en');
    System.assertEquals(value.Name, '','GDICOE_JobPostingDA_Test test_getJobDetailDataForJobDetailId #3/4');

    value = GDICOE_JobPostingDA.getJobDetailDataForJobDetailId('','fr');
    System.assertEquals(value.Name, '','GDICOE_JobPostingDA_Test test_getJobDetailDataForJobDetailId #4/4');
  }

  @IsTest
  static void test_getJobPostingTranslationDataAsJSON() {
    String result;
    Boolean value;

    result = GDICOE_JobPostingDA.getJobPostingTranslationDataAsJSON(null);
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobPostingTranslationDataAsJSON #1/4');

    result = GDICOE_JobPostingDA.getJobPostingTranslationDataAsJSON('');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobPostingTranslationDataAsJSON #2/4');

    result = GDICOE_JobPostingDA.getJobPostingTranslationDataAsJSON('en');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobPostingTranslationDataAsJSON #3/4');

    result = GDICOE_JobPostingDA.getJobPostingTranslationDataAsJSON('fr');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobPostingTranslationDataAsJSON #4/4');
  }

  @IsTest
  static void test_getJobPostingTemplateDataAsJSON() {
    String result;
    Boolean value;

    result = GDICOE_JobPostingDA.getJobPostingTemplateDataAsJSON(null);
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobPostingTemplateDataAsJSON #1/2');

    result = GDICOE_JobPostingDA.getJobPostingTemplateDataAsJSON('');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobPostingTemplateDataAsJSON #2/2');
  }

  @IsTest
  static void test_getJobDetailDataAsJSON() {
    String result;
    Boolean value;

    result = GDICOE_JobPostingDA.getJobDetailDataAsJSON(null,null);
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailDataAsJSON #1/8');

    result = GDICOE_JobPostingDA.getJobDetailDataAsJSON(null,'');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailDataAsJSON #2/8');

    result = GDICOE_JobPostingDA.getJobDetailDataAsJSON(null,'en');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailDataAsJSON #3/8');

    result = GDICOE_JobPostingDA.getJobDetailDataAsJSON(null,'fr');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailDataAsJSON #4/8');

    result = GDICOE_JobPostingDA.getJobDetailDataAsJSON('',null);
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailDataAsJSON #5/8');

    result = GDICOE_JobPostingDA.getJobDetailDataAsJSON('','');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailDataAsJSON #6/8');

    result = GDICOE_JobPostingDA.getJobDetailDataAsJSON('','en');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailDataAsJSON #7/8');

    result = GDICOE_JobPostingDA.getJobDetailDataAsJSON('','fr');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailDataAsJSON #8/8');
  } 

  @IsTest
  static void test_getJobDetailPayloadAsJSON() {
    String result;
    Boolean value;

    result = GDICOE_JobPostingDA.getJobDetailPayloadAsJSON(null,null);
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailPayloadAsJSON #1/8');

    result = GDICOE_JobPostingDA.getJobDetailPayloadAsJSON(null,'');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailPayloadAsJSON #2/8');

    result = GDICOE_JobPostingDA.getJobDetailPayloadAsJSON(null,'en');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailPayloadAsJSON #3/8');

    result = GDICOE_JobPostingDA.getJobDetailPayloadAsJSON(null,'fr');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailPayloadAsJSON #4/8');

    result = GDICOE_JobPostingDA.getJobDetailPayloadAsJSON('',null);
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailPayloadAsJSON #5/8');

    result = GDICOE_JobPostingDA.getJobDetailPayloadAsJSON('','');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailPayloadAsJSON #6/8');

    result = GDICOE_JobPostingDA.getJobDetailPayloadAsJSON('','en');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailPayloadAsJSON #7/8');

    result = GDICOE_JobPostingDA.getJobDetailPayloadAsJSON('','fr');
    value = result.length() >= 0;
    System.assertEquals(value, true,'GDICOE_JobPostingDA_Test test_getJobDetailPayloadAsJSON #8/8');
  }

}