# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  if page.respond_to? :should
    page.body.should match /#{e1}.*#{e2}/m
  else
    # fails by reverse sorting
    assert(page.body.should match /#{e1}.*#{e2}/m, 'error')
  end
end

# Make it easier to express checking or unchecking several boxes at once
# "When I uncheck the following ratings: PG, G, R"
# "When I check the following ratings: G"
#When /I (un)?check the following ratings: (.*)/ do |is_uncheck, rating_list|
When /I (un)?check the following ratings: (.*)/ do |not_checked, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/,\s*/).each do |rating|
    field = "ratings_#{rating}"
    if not_checked
      uncheck(field)
    else
      check(field)
    end
  end
end

Then /I should see (.*) of the movies/ do |count|
  if count == "none" or count == 0
    page.should have_no_css("#movielist tr")
  else
    page.has_css?("#movielist tr", :count => count == "all" ? 10 : count)
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |m1, m2|
  m = Movie.find_by_title(m1)
  m.director.should match m2
end

