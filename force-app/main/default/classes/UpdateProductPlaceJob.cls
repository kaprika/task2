global with sharing class UpdateProductPlaceJob implements Schedulable {

    global void execute(SchedulableContext ctx) {
        DefineProductPlaceBatch definePlaceBatch = new DefineProductPlaceBatch();
        Database.executeBatch(definePlaceBatch);
    }
}