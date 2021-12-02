@IsTest
public class TestDataFactory {

    public static Product2 createDummyProduct(String name, Integer rating, Boolean needInsert) {
        Product2 product = new Product2(Name = name, Rating__c = rating);
        if (needInsert) {
            insert product;
        }
        return product;
    }

    public static List<Product2> createDummyListOfProducts(Integer count, String name, Integer rating, Boolean needInsert) {
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < count; i++) {
         //   String name = i + 1 + ' product';
         //   Integer rating = Integer.valueof((Math.random() * 100));
            products.add(createDummyProduct(name, rating, false));
        }
        if (needInsert) {
            insert products;
        }
        return products;
    }
}
