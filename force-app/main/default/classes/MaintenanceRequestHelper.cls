public with sharing class MaintenanceRequestHelper {
    private static Boolean isEnabled;

    static{
        isEnabled = true;
    }

    public static Boolean isTriggerEnabled(){
        return isEnabled;
    }

    public static Boolean disableTrigger(){
        return isEnabled = false;
    }

    public static Boolean enableTrigger(){
        return isEnabled = true;
    }
    // ----------------------x----------------------------
    public static void createNewMaintenanceRequest(List<Case> casesLst, Map<Id,Case> oldCaseMap){
        Set<String> caseIds = new Set<String>();
        List<Case> newMRLst = new List<Case>();
        for(Case c: casesLst){
            caseIds.add(c.Id);
        }

        for(Case cs: casesLst){
            Datetime dt = (Datetime) cs.get('CreatedDate');
            Case oldCase = oldCaseMap.get(cs.Id);
            if(checkStatus(cs, oldCase)){
                Case newRM = new Case(
                    Vehicle__c = cs.Vehicle__c,
                    Type = 'Routine Maintenance',
                    Subject = cs.Subject != null ? cs.Subject : 'Routine Maintenance',
                    Date_Reported__c = dt.date(),
                    Date_due__c = system.today().addDays(15)
                );
                newMRLst.add(newRM);
            }
        }
        if(newMRLst.size() > 0){
            insert newMRLst;
        }
    }
    public static Boolean checkStatus(Case newCase, Case old){
        return newCase.Status == 'Closed' && (newCase.Type == 'Reapir' || newCase.Type == 'Routine Maintenance') && old.Status != 'Closed';
    }
}