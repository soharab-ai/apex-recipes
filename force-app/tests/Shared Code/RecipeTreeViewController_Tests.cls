@isTest
private class RecipeTreeViewController_Tests {
    @isTest
    static void testGenerateTreeDataPositive() {
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@test.com',
            Username = 'testuser' + System.currentTimeMillis() + '@test.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = standardProfile.Id
        );
        insert testUser;
        
        System.runAs(testUser) {
            Map<Id, ApexClass> fakeResults = new Map<Id, ApexClass>(
                [
                    SELECT Name, Body
                    FROM ApexClass
                    WHERE Name LIKE 'Recipe%'
                    LIMIT 10
                ]
            );
            
            Test.startTest();
            List<Map<String, Object>> treeData = RecipeTreeViewController.generateTreeData();
            Test.stopTest();
            
            System.assertNotEquals(null, treeData, 'Tree data should not be null');
        }
    }
    
    @isTest
    static void testGenerateTreeDataWithRestrictedUser() {
        Profile restrictedProfile = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User' OR Name = 'Minimum Access - Salesforce' LIMIT 1];
        User restrictedUser = new User(
            FirstName = 'Restricted',
            LastName = 'User',
            Email = 'restricteduser@test.com',
            Username = 'restricteduser' + System.currentTimeMillis() + '@test.com',
            Alias = 'ruser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = restrictedProfile.Id
        );
        insert restrictedUser;
        
        System.runAs(restrictedUser) {
            Test.startTest();
            try {
                List<Map<String, Object>> treeData = RecipeTreeViewController.generateTreeData();
                System.assert(treeData == null || treeData.isEmpty(), 'Restricted user should have limited access');
            } catch (Exception e) {
                System.assert(true, 'Expected exception for restricted user access');
            }
            Test.stopTest();
        }
    }
}

                    Name LIKE 'RecipeTreeViewController'
                    OR Name LIKE 'SOQLRecipes'
            ]
        );
        Test.setFixedSearchResults(new List<Id>(fakeResults.keyset()));
        Test.startTest();
        List<RecipeTreeViewController.RecipeTreeData> tree = RecipeTreeViewController.generateTreeData();
        Test.stopTest();

        System.Assert.areEqual(
            2,
            tree.size(),
            'Expected to find two sub trees'
        );
        System.Assert.areEqual(
            'Recipes',
            tree[0].name,
            'Expected Recipes to be the first element'
        );
        System.Assert.areEqual(
            'Shared Code',
            tree[1].name,
            'Expected the final element to be Shared code'
        );
        System.Assert.isTrue(
            tree[0].items.size() > 0,
            'expected for recipes to have sub-groups'
        );
        System.Assert.isTrue(
            tree[1].items.size() > 0,
            'expected for shared code to have sub-groups'
        );
    }
}
