public with sharing class ProductTriggerHandler extends TriggerHandler {
    public ProductTriggerHandler() {

    }

    public override void afterInsert() {

        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

        Pricebook2 pricebookPadrao = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        for (Product2 prod : (List<Product2>) Trigger.new) {
            pricebookEntries.add(new PricebookEntry(UnitPrice = 0.00, Product2Id = prod.Id, Pricebook2Id = pricebookPadrao.Id, CurrencyIsoCode = 'USD'));
            pricebookEntries.add(new PricebookEntry(UnitPrice = 0.00, Product2Id = prod.Id, Pricebook2Id = pricebookPadrao.Id, CurrencyIsoCode = 'BRL'));
            pricebookEntries.add(new PricebookEntry(UnitPrice = 0.00, Product2Id = prod.Id, Pricebook2Id = pricebookPadrao.Id, CurrencyIsoCode = 'AOA'));
        }

        insert pricebookEntries;
    }
}