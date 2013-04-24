name 'base'

run_list "recipe[apt]",
         "recipe[git]",
         "recipe[postfix]",
         "recipe[ntp]",
         "recipe[vim]"