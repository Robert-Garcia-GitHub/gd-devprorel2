@IsTest
public with sharing class GDICOE_JobPostingDA_Test {
  @IsTest
  static void test_getJobListRecord() {
    List<GDICOE_Job_List__c> value = GDICOE_JobPostingDA.getJobListRecord('');
    System.assertEquals(value.isEmpty(), true);
  }

  @IsTest
  static void test_getJobPostingRecords() {
    List<GDICOE_Job_List__c> joblist = new List<GDICOE_Job_List__c>();
    List<GDICOE_Job_Posting__c> value;

    value = GDICOE_JobPostingDA.getJobPostingRecords(null);
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingRecords #1/2');

    value = GDICOE_JobPostingDA.getJobPostingRecords(joblist);
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingRecords #2/2');
  }

  @IsTest
  static void test_getJobDetailRecords() {
    List<GDICOE_Job_Posting__c> jobposting = new List<GDICOE_Job_Posting__c>();
    List<GDICOE_Job_Detail__c> value;

    value = GDICOE_JobPostingDA.getJobDetailRecords(null,null);
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingRecords #1/4');

    value = GDICOE_JobPostingDA.getJobDetailRecords(null,'');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingRecords #2/4');

    value = GDICOE_JobPostingDA.getJobDetailRecords(jobposting,null);
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingRecords #3/4');

    value = GDICOE_JobPostingDA.getJobDetailRecords(jobposting,'');
    System.assertEquals(value.isEmpty(), true,'GDICOE_JobPostingDA_Test test_getJobPostingRecords #4/4');
}

  @IsTest
  static void test_getJobDetailRecord() {
    List<GDICOE_Job_Detail__c> value;

    value = GDICOE_JobPostingDA.getJobDetailRecord(null,'');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobDetailRecord('','');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobDetailRecord(null,'en');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobDetailRecord('','en');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobDetailRecord(null,'fr');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobDetailRecord('','fr');
    System.assertEquals(value.isEmpty(), true);
  }

  @IsTest
  static void test_getJobPostings() {
    List<GDICOE_Job_Detail__c> value;

    value = GDICOE_JobPostingDA.getJobPostings(null,'');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobPostings('','');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobPostings(null,'en');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobPostings('','en');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobPostings(null,'fr');
    System.assertEquals(value.isEmpty(), true);

    value = GDICOE_JobPostingDA.getJobPostings('','fr');
    System.assertEquals(value.isEmpty(), true);
  }

}