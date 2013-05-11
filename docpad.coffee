# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://website.com"

			services:
				facebookLikeButton:
					applicationId: '455533301199949'
				facebookFollowButton:
					applicationId: '455533301199949'
					username: 'mikeumus'
				twitterTweetButton: 'subset_3'
				twitterFollowButton: 'subset_3'
				githubFollowButton: 'mikeumus'

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.website.com',
				'website.herokuapp.com'
			]

			# The default title of our website
			title: "RL Spike Mark 1"

			# The website description (for SEO)
			description: """
				When your website appears in search results in say Google, the text here will be shown underneath your website's title.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
				"""

			# The website author's name
			author: "Your Name"

			# The website author's email
			email: "your@email.com"

			# Styles
			styles: [
				"/assets/bootstrap/css/bootstrap-min.css"
				"/assets/css/style.css"
				"/assets/css/supersized.css"
				"http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700"
        		"http://fonts.googleapis.com/css?family=Patua+One"
        		"http://fonts.googleapis.com/css?family=Allerta"
			]

			# Scripts
			scripts: [
				"//cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js",
				"//cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js",
				"/scripts/script.js"
				"/assets/js/jquery-countdown.js"
        		#"/assets/js/supersized.js"
        		#"/assets/js/supersized-init.js"
       			"/assets/js/jquery-tweet.js"
        		"/assets/js/jflickrfeed.js"
        		"/assets/js/scripts.js"
        		"/assets/bootstrap/js/bootstrap-min.js"
			]



		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		posts: (database) ->
			database.findAllLive({tags:$has:'post'}, [date:-1])


	# =================================
	# Plugins

	plugins:
		downloader:
			downloads: [
				{
					name: 'Twitter Bootstrap'
					path: 'src/files/vendor/twitter-bootstrap'
					url: 'https://nodeload.github.com/twitter/bootstrap/tar.gz/master'
					tarExtractClean: true
				}
			]


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
}


# Export our DocPad Configuration
module.exports = docpadConfig