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
        List<Equipment_Maintenance_Item__c> newEMILst = new List<Equipment_Maintenance_Item__c>();
        for(Case c: casesLst){
            caseIds.add(c.Id);
        }
        for(Equipment_Maintenance_Item__c emi: [SELECT Id, Equipment__c 
                                                FROM Equipment_Maintenance_Item__c 
                                                WHERE Maintenance_Resquest__c IN: caseIds])
        {
            for(Case cs: casesLst){
                Datetime dt = (Datetime) cs.get('CreatedDate');
                Case oldCase = oldCaseMap.get(cs.Id);
                if(checkStatus(cs, oldCase)){
                    Case newRM = new Case(
                        Vehicle__c = cs.Vehicle__c,
                        Type = 'Routine Maintenance',
                        Subject = cs.Subject != null ? cs.Subject : 'Routine Maintenance',
                        Date_Reported__c = dt.date(),
                        Date_due__c = System.today().addDays(15),
                        ProductId = emi.Equipment__c
                    );
                    newMRLst.add(newRM);

                    Equipment_Maintenance_Item__c newEMI = new Equipment_Maintenance_Item__c(
                        Equipment__c = emi.Equipment__c,
                        Quantity__c = emi.Quantity__c,
                        Maintenance_Request__c = NewMR.Id
                    );
                    newEMILst.add(newEMI);
                }
            }

        }
        if(newMRLst.size() > 0){
            insert newMRLst;
        }
        if(newEMILst.size() > 0){
            insert newEMILst;
        }
    }
    public static Boolean checkStatus(Case newCase, Case old){
        return newCase.Status == 'Closed' && (newCase.Type == 'Reapir' || newCase.Type == 'Routine Maintenance') && old.Status != 'Closed';
    }
}