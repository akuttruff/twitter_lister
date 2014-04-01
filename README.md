Twitter_Lister
====================

This application gathers the Twitter bios of all members of a list and renders a visualized selection of their most commonly used words using [d3-cloud](https://github.com/jasondavies/d3-cloud).

Much of the net/HTTP code draws from the [Codecademy](www.codecademy.com) Twitter API lessons. The site has some great tutorials, check them out!

To keep them from public view, the Twitter API keys (CONSUMER_KEY, CONSUMER_SECRET) and access tokens (TOKEN_KEY, TOKEN_SECRET) are stored as Heroku environment variables.

To Do:
====================

- Lister.process needs to be refactored