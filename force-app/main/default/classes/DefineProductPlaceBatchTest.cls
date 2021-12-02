@IsTest
private class DefineProductPlaceBatchTest {

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
        Test.startTest();
        DefineProductPlaceBatch productBatch = new DefineProductPlaceBatch();
        Database.executeBatch(productBatch);
        Test.stopTest();
        System.debug('MAP :'+ DefineProductPlaceBatch.testPlaceMap);
        List<Product2> products = [SELECT Id, Rating__c FROM Product2];
        System.assertEquals(7, products.size());
        System.assertEquals('7', DefineProductPlaceBatch.testPlaceMap.get(0));
        System.assertEquals('2-6', DefineProductPlaceBatch.testPlaceMap.get(50));
        System.assertEquals('1', DefineProductPlaceBatch.testPlaceMap.get(100));
    }
}
