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
        if (String.isBlank(keyword)) {
            return new List<List<SObject>>();
        }
        String sanitizedKeyword = sanitizeSOSLSearchTerm(keyword);
        List<List<SObject>> searchResults = [
            FIND :sanitizedKeyword
            IN NAME FIELDS
            RETURNING account(name), contact(lastname, account.Name)
        ];
        return searchResults;
    }
    
    /**
     * Sanitizes SOSL search terms to prevent SOSL injection attacks
     * @param searchTerm The raw search term to sanitize
     * @return A sanitized version of the search term safe for SOSL queries
     */
    public static String sanitizeSOSLSearchTerm(String searchTerm) {
        if (String.isBlank(searchTerm)) {
            return Search_Settings__c.getInstance().Default_Search_Term__c != null ? 
                   Search_Settings__c.getInstance().Default_Search_Term__c : '';
        }
        // Remove SOSL special operators and characters that could alter query behavior
        String sanitized = searchTerm.replaceAll('[\\\\\'\\*\\?\\&\\|\\!\\{\\}\\[\\]\\(\\)\\^\\~\\:\\+\\-]', '');
        // Ensure minimum search term requirements (2+ chars for SOSL)
        if (sanitized.length() < 2) {
            return Search_Settings__c.getInstance().Default_Search_Term__c != null ? 
                   Search_Settings__c.getInstance().Default_Search_Term__c : '';
        }
        return sanitized;
    }

        return searchResults;
    }
}
