@IsTest
private class UpdateProductPlaceBatchTest {
   
    @testSetup
    static void setup() {
        List<Product2> products = TestDataFactory.createDummyListOfProducts(5, 'Test', 50, false);
        Product2 product1 = TestDataFactory.createDummyProduct('Test', 0, false);
        Product2 product2 = TestDataFactory.createDummyProduct('Test', 100, false);
        products.add(product1);
        products.add(product2);
        insert products;
    }

    @IsTest
    static void test() {
        Map<Integer, String> placeMap = new Map<Integer, String>();
        placeMap.put(0, '7');
        placeMap.put(50, '2-6');
        placeMap.put(100, '1');
        Test.startTest();
        UpdateProductPlaceBatch productBatch = new UpdateProductPlaceBatch(placeMap);
        Database.executeBatch(productBatch);
        Test.stopTest();
        List<Product2> products = [SELECT Id, Rating__c, Place__c FROM Product2];
        System.assertEquals(7, products.size());
        for (Product2 product : products) {
            if (product.Rating__c == 100) {
                System.assertEquals('1', product.Place__c);
            } else if (product.Rating__c == 50) {
                System.assertEquals('2-6', product.Place__c);
            } else if (product.Rating__c == 0) {
                System.assertEquals('7', product.Place__c);    
            }
        }
    }
}
