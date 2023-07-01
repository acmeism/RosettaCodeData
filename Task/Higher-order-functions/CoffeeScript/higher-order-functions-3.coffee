bowl = ["Cheese", "Tomato"]

smash = (ingredient) ->
    return "Smashed #{ingredient}"

contents = smash ingredient for ingredient in bowl
# => ["Smashed Cheese", "Smashed Tomato"]
