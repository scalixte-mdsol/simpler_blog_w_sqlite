Feature:
  In order to create a blog with contents
  On Behalf of some author
  I want to create a single article with text content

  @single
  Scenario: Create articles by author only
    Given I have articles authored by Julio, Marino, and Garcia
    When I go to the main page
    Then I should see "Julio"
    And I should see "Marino"
    And I should see "Garcia"

  @multiple
  @first
  Scenario: Create multiple articles onto the database
   Given I am on the main page
   When I insert these articles:
     | author  | title           | content                                                                         | count |
     | Stanley | La vie en rose  | Je soufre dans le monde, mais quand je la vois je me sens bien, tout est bien.  | 1     |
     | Julio   | La vida en rosa | Dolor in mundo, cum tamen ego vidi bonum, omne bonum.                           | 2     |
     | Ceasar  | Vita in Rosea   | Yo sufro en el mundo, pero cuando lo veo me siento bien, todo está bien.        | 3     |
    And I go to the main page
    Then I should see under "Author": Stanley, Julio, and Ceasar
    And I should have 3 articles

  @multiple
  @second
  Scenario Outline: Create multiple articles and verify each author and title onto the database
    Given I have no articles in the blog
    And I am on the main page
    When I insert these articles:
      | author  | title           | content                                                                         | count |
      | Stanley | La vie en rose  | Je soufre dans le monde, mais quand je la vois je me sens bien, tout est bien.  | 0     |
      | Julio   | La vida en rosa | Dolor in mundo, cum tamen ego vidi bonum, omne bonum.                           | 2     |
      | Ceasar  | Vita in Rosea   | Yo sufro en el mundo, pero cuando lo veo me siento bien, todo está bien.        | 3     |
    And I go to the main page
    Then I should see "<author>"
    And I should see "<title>"
    And I should have 3 articles

  Examples:
    | author  | title           |
    | Stanley | La vie en rose  |
    | Julio   | La vida en rosa |
    | Ceasar  | Vita in Rosea   |



  @addition
  Scenario Outline: Create multiple articles starting from a blank database
    Given I am on the main page
    When I click on New Article
    And I enter a value for "Author" as "<author>"
    And I enter a value for "Title" as "<title>"
    And I enter a value for "Content" as "<content>"
    And I press "Create"
    Then I should see "New article created"
    And I should see <count> articles
    And I should see "<author>"
    And I should see "<title>"

  Examples:
    | author  | title           | content                                                                         | count |
    | Stanley | La vie en rose  | Je soufre dans le monde, mais quand je la vois je me sens bien, tout est bien.  | 1     |
    | Julio   | La vida en rosa | Dolor in mundo, cum tamen ego vidi bonum, omne bonum.                           | 1     |
    | Ceasar  | Vita in Rosea   | Yo sufro en el mundo, pero cuando lo veo me siento bien, todo está bien.        | 1     |


  @pre_delete
  Scenario: Create multiple articles starting from a blank database
    Given I have no articles in the blog
    And I am on the main page
    Then I should see 0 article

  @delete
  Scenario Outline: Create multiple articles starting from a blank database
    Given I have no articles in the blog
    And I am on the main page
    When I click on New Article
    And I enter a value for "Author" as "<author>"
    And I enter a value for "Title" as "<title>"
    And I enter a value for "Content" as "<content>"
    And I press "Create"
    Then I should see "New article created"
    And I should see <count> articles
    And I should see "<author>"
    And I should see "<title>"

  Examples:
    | author  | title           | content                                                                         | count |
    | Stanley | La vie en rose  | Je soufre dans le monde, mais quand je la vois je me sens bien, tout est bien.  | 1     |
    | Julio   | La vida en rosa | Dolor in mundo, cum tamen ego vidi bonum, omne bonum.                           | 1     |
    | Ceasar  | Vita in Rosea   | Yo sufro en el mundo, pero cuando lo veo me siento bien, todo está bien.        | 1     |


