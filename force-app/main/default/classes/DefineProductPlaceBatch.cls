public with sharing class DefineProductPlaceBatch implements Database.Batchable<sObject>, Database.Stateful{
    public Map<Integer, Integer> ratingMap {get; set;}
    @TestVisible static Map<Integer, String> testPlaceMap;

    public DefineProductPlaceBatch() {
        ratingMap = new Map<Integer, Integer>();
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                    'SELECT Id, Rating__c FROM Product2 WHERE Rating__c != null'
        );
    }
   
    public void execute(Database.BatchableContext bc, List<Product2> scope) {
        for (Product2 product : scope) {
            Integer rating = Integer.valueOf(product.Rating__c);
            if (ratingMap.keySet().contains(rating)) {
                Integer counter = ratingMap.get(rating);
                counter++;
                ratingMap.put(rating, counter);
            } else {
                ratingMap.put(rating, 1);
            }
        }
        System.debug('MAP : ' + ratingMap);
    }
    
    public void finish(Database.BatchableContext bc) {
        Map<Integer, String> placeMap = new Map<Integer, String>();
        Set<Integer> ratingSet = ratingMap.keySet();
        List<Integer> ratingList = new List<Integer>(ratingSet);
        ratingList.sort();
        Integer startPlace = 1;
        Integer endPlace = 1;
        for (Integer i = ratingList.size() - 1; i >= 0; i--) {
            endPlace = startPlace + ratingMap.get(ratingList.get(i)) - 1;
            if (startPlace == endPlace) {
                List<Object> parameters = new List<Object> {startPlace};
                String formattedPlace = String.format('{0}', parameters);
                placeMap.put(ratingList.get(i), formattedPlace);
            } else {
                List<Object> parameters = new List<Object> {startPlace, endPlace};
                String formattedPlace = String.format('{0}-{1}', parameters);
                placeMap.put(ratingList.get(i), formattedPlace);
            }
            startPlace = endPlace + 1;
        }
        testPlaceMap = placeMap;
        if (!Test.isRunningTest()) {
            UpdateProductPlaceBatch updatePlace = new UpdateProductPlaceBatch(placeMap);
            Database.executeBatch(updatePlace);
        }
    }
}
