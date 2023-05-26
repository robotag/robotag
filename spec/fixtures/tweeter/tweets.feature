Feature: Tweets

  @tweets
  Scenario Outline: A user has tweets
    Given I login as a user <user>
    When I visit the my tweets page
    Then I see <tweet_count> tweets
    Examples:
      | user   | tweet_count |
      | @jbird | 20          |
      | @p     | 12          |
      | @zfy   | 3           |

  @tweets
  Scenario: Tweets can be deleted
    Given I have a user @jbird
    When I visit the my tweets page
    Then I see 20 tweets
    When I delete 3 tweets
    Then I see 17 tweets

  @followers
  Scenario Outline: My followers
    Given I login as a user <user>
    When I visit the my followers page
    Then I see <follower_count> tweets
    Examples:
      | user   | follower_count |
      | @jbird | 2              |

  @following
  Scenario Outline: I'm following
    Given I login as a user <user>
    When I visit the I'm following page
    Then I see <following_count> tweets
    Examples:
      | user   | following_count |
      | @jbird | 108             |
      | @p     | 1               |

  @following @wip
  Scenario Outline: Following @elom
    Given I login as a user <user>
    When I visit the I'm following @elom page
    Then I see <do_i> for the I'm following @elom indicator
    Examples:
      | user   | do_i |
      | @jbird | yep  |
      | @p     | nope |

  @following @wip
  Scenario: User @elom following @elom
    Given I login as a user @elom
    When I visit the I'm following @elom page
    Then user @elom sees a 3d statue of himself standing on a 3d yacht
