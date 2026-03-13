public with sharing class ProductTriggerHandler {
    public ProductTriggerHandler() {

    }

    public void OnAfterInsert(List<Product2> produtos) {
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

        Pricebook2 pricebookPadrao = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        for (Product2 prod : produtos) {
            pricebookEntries.add(new PricebookEntry(UnitPrice = 0.00, Product2Id = prod.Id, Pricebook2Id = pricebookPadrao.Id));
        }

        insert pricebookEntries;
    }
}