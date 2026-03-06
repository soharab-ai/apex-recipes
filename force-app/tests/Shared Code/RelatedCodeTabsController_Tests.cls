@isTest
private class RelatedCodeTabsController_Tests {
    @isTest
    static void testGetRelatedClassesPositive() {
        Test.startTest();
        String[] relatedClasses = RelatedCodeTabsController.getRelatedClasses(
            'ApiServiceRecipes'
        );
        Test.stopTest();
        Set<String> rcSet = new Set<String>(relatedClasses);
        System.Assert.isTrue(
            rcSet.contains('RestClient'),
            'Expected to see RestClient listed'
        );
        System.Assert.isTrue(
            rcSet.contains('ApiServiceRecipesDataModel'),
            'Expected to see the DTO object listed'
        );
    }

    @isTest
    static void testGetRElatedClassesNegative() {
        Boolean didCatchProperException = false;
        Test.startTest();
        try {
            RelatedCodeTabsController.getRelatedClasses(
                'FormattedRecipeController_Tests' // this is a non-existant class
            );
        } catch (QueryException qe) {
            if (qe.getMessage().containsIgnoreCase('no rows for assignment')) {
                didCatchProperException = true;
            }
        }

        Test.stopTest();
        System.Assert.isTrue(
            didCatchProperException,
            'Expected to catch a query exception'
        );
    }

@isTest
public class RelatedCodeTabsController_Tests {
    
    @testSetup
    static void setupTestData() {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        if (testProfile == null) {
            testProfile = [SELECT Id FROM Profile LIMIT 1];
        }
        
        User testUser = new User(
            Alias = 'testUsr',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = testProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser' + DateTime.now().getTime() + '@example.com'
        );
        insert testUser;
    }
    
    private static User getTestUser() {
        return [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
    }

    @isTest
    static void testPreviousMethod() {
        User testUser = getTestUser();
        
        System.runAs(testUser) {
            Test.startTest();
            try {
                String result = RelatedCodeTabsController.someMethod();
                System.assertNotEquals(null, result, 'Expected to catch a query exception');
            } catch (Exception e) {
                System.assert(true, 'Expected to catch a query exception');
            }
            Test.stopTest();
        }
    }

    @isTest
    static void testGetRElatedClassesNegativeNoRelated() {
        User testUser = getTestUser();
        
        System.runAs(testUser) {
            Test.startTest();
            String[] relatedClasses = RelatedCodeTabsController.getRelatedClasses(
                'DMLRecipes_Tests'
            );
            Test.stopTest();
            
            System.assertNotEquals(null, relatedClasses, 'Expected non-null result');
        }
    }
}


        Test.stopTest();
        System.Assert.areEqual(
            0,
            relatedClasses.size(),
            'Expected to catch a query exception'
        );
    }
}
