/**
 * @description       : 
 * @author            : Bharath Kumar
 * @group             : 
 * @last modified on  : 09-13-2020
 * @last modified by  : Bharath Kumar
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   09-13-2020   Bharath Kumar   Initial Version
**/
/**
 * Credits -  https://salesforce.stackexchange.com/questions/236478/apex-break-list-into-multiple-small-lists-before-processing
 */
@isTest
private class ListsTest {

    @isTest
    static void testCorrectPartions(){
        List<Integer> records = new List<Integer> {
            1, 2, 3, 4, 5
            };
        Test.startTest();
            List<List<Integer>> actual = (List<List<Integer>>) Lists.doPartions(records, 2, List<List<Integer>>.class);
        Test.stopTest();
        System.assertEquals(3, actual.size(), 'Incorrect number of partions');
        Integer tempNumber = 1;
        for(List<Integer> itemsActual :actual){
            for(Integer numb :itemsActual){
                System.assertEquals(tempNumber, numb, 'Order of elements isn\'t saved');
                ++tempNumber;
            }
        }
    }
}