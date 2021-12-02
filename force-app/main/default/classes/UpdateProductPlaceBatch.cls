public with sharing class UpdateProductPlaceBatch implements Database.Batchable<sObject>, Database.Stateful {
    private Map<Integer, String> placeMap;

    public UpdateProductPlaceBatch(Map<Integer, String> placeMap) {
        this.placeMap = placeMap;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                    'SELECT Id, Rating__c, Place__c FROM Product2 WHERE Rating__c != null'
        );
    }
   
    public void execute(Database.BatchableContext bc, List<Product2> scope) {
        List<Product2> updatedProducts = new List<Product2>();
        for (Product2 product : scope) {
            Integer rating = Integer.valueOf(product.Rating__c);
            product.Place__c = placeMap.get(rating);
            updatedProducts.add(product);
        }
        update updatedProducts;
    }
    
    public void finish(Database.BatchableContext bc) {
    }
}
