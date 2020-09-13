/**
 * @description       : This scheduler runs every hour. The scheduler will user the AsyncApexFramework to submit the WrkfcePlanDelegatorBatch. 
 * @author            : Bharath Kumar
 * @group             : 
 * @last modified on  : 09-13-2020
 * @last modified by  : Bharath Kumar
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   09-12-2020   Bharath Kumar   Initial Version
**/
public class WrkfcePlanScheduler implements Schedulable {

    public void execute(SchedulableContext scheduleContext) {
        /**
         * This scheduler will run every hour.
         * Use the AsyncApexFramework to submit a batch - WrkfcePlanDelegatorBatch.
         * The batch size is set to 15K for now, considering 200 * 60 = 12,000 + (25% failure rate).
         * */
        ID batchprocessid = AsyncApexFramework.submitBatch(new WrkfcePlanDelegatorBatch(), 15000, null, false);
        AsyncApexFramework.flush();
	}
}