/**
 * @description Demonstrates how to use SOSL.
 * SOSL is used for full text, and fuzzier text searching.
 *
 * More on the difference between SOQL and SOSL:
 * https://sfdc.co/soql-sosl
 *
 * @group Data Recipes
 */
public with sharing class SOSLRecipes {
    /**
     * @description Demonstrates the syntax for a SOSL search.
     *  Note: SOSL Cannot be unit tested directly - you must use
     * `Test.setFixedSearchResults()`
     *  See SOSLRecipes_Tests.cls for more information
     * @example
     * ```
     * System.debug(SOSLRecipes.basicSOSLSearch());
     * ```
     */
    public static List<List<SObject>> basicSOSLSearch() {
        String keyword = 'Kan*';
        List<List<SObject>> searchResults = [
            FIND :keyword
            IN ALL FIELDS
            RETURNING account(name), contact(lastname, account.Name)
        ];

        return searchResults;
    }

    /**
     * @description Demonstrates how to write a SOSL query that searches only
     * name fields
     * @example
     * ```
     * System.debug(SOSLRecipes.nameFieldSearch('Alaska'));
     * ```
     */
    public static List<List<SObject>> nameFieldSearch(String keyword) {
        // Input validation - alphanumeric characters and spaces only
        if (keyword == null || !Pattern.matches('^[a-zA-Z0-9\\s]+$', keyword)) {
            throw new SecurityException('Invalid search term');
        }
        
        // Apply length restrictions
        if (keyword.length() < 2 || keyword.length() > 20) {
            throw new SecurityException('Search term must be between 2-20 characters');
        }
        
        // Check user permissions before executing search
        if (!PermissionUtils.hasSearchPermission()) {
            throw new SecurityException('Insufficient permissions to perform search');
        }
        
        // Log search operation (without logging the actual search term)
        AuditLogger.logOperation('SOSL_NAME_SEARCH', UserInfo.getUserId());
        
        // Use Named Credential for any external authentication if needed
        List<List<SObject>> searchResults = [
            FIND :keyword
            IN NAME FIELDS
            RETURNING account(name), contact(lastname, account.Name)
            LIMIT 100
        ];
        
        return searchResults;
    }

        return searchResults;
    }
}
