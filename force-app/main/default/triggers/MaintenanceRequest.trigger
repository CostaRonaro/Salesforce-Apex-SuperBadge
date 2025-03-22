trigger MaintenanceRequest on Case (before insert, before update, after insert, after update, before delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
        }
        when BEFORE_DELETE {
        }
        when BEFORE_UPDATE {
            MaintenanceRequestHelper.createNewMaintenanceRequest(Trigger.new, Trigger.oldMap);
        }
        when AFTER_INSERT {
        }
        when AFTER_UPDATE {
        }
        when AFTER_DELETE {
        }
    }
}