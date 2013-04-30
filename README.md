Setting up Discourse on Heroku
==============================
*Last updated for version 0.8.5*

If you follow this guide, you should be able to run fully-functional Discourse on Heroku for free (up to a point)

[view original README](README_ORIG.md)

Clone this repo
---------------
`git clone git://github.com/swrobel/discourse-heroku.git discourse`

Tell Heroku about your app
--------------------------
`heroku apps:create [YOUR_APP_NAME]`

Install addons
--------------
`heroku addons:add heroku-postgresql:dev --version=9.2`

might as well use Postgres 9.2 although discourse will work with 9.1, which is Heroku's default at time of writing

`heroku addons:add mandrill:starter rediscloud:20 memcachier:dev scheduler newrelic:standard`

mandrill is for email delivery, although the free mailgun or sendgrid plans will work as well (just update the appropriate config vars). memcachier is for rails cache storage.

`heroku labs:enable user-env-compile`

This will enable asset precompilation to complete successfully.

The first time this is uploaded to heroku - asset precompilation will fail because there is no database setup.

--INSERT INSTRUCTIONS FOR FORCING RELOAD ON HEROKU-- (to be done after rake db:migrate is run)

Setup config vars
-----------------
1. `rake secret`
1. copy the output
1. `heroku config:add SECRET_TOKEN=<paste here>`
1. copy your API key from [your Heroku account](https://dashboard.heroku.com/account)
1. `heroku config:add HEROKU_API_KEY=<paste here>`
1. `heroku config:add SMTP_SERVER=smtp.mandrillapp.com SMTP_PORT=587 HEROKU_APP=<heroku_app_name>`
1. `heroku config:add RUBY_GC_MALLOC_LIMIT=90000000` (per [Discourse team's recommendation](http://meta.discourse.org/t/tuning-ruby-and-rails-for-discourse/4126))
2. `heroku config:add MANDRILL_USERNAME=<your mandrill email>`
2. `heroku config:add MANDRILL_APIKEY=<your mandrill api key>`

Push the code, migrate, seed
----------------------------
1. `git push heroku master`
1. `heroku run rake db:migrate`
1. `heroku run rake db:seed_fu`

Setup scheduler tasks
---------------------
`heroku addons:open scheduler`

Set up the scheduled tasks as follows:

        TASK                       | FREQUENCY
        --------------------------------------------

        rake enqueue_digest_emails |  Daily               

        rake category_stats        | Daily              

        rake periodical_updates    | Every 10 minutes
                                   
        rake version_check         | Daily
        
Create an admin user
--------------------
You must create an original admin user. To do this, first create a user account using the web-gui. An activation email will be sent to your inbox. You may need to copy the activation link address and replace the domain portion of it with your apps domain name (HEROKU_APP_NAME.herokuapp.com)

Next run `heroku run console`

````
user = User.first
user.admin = true
user.moderator = true (this is optional)
user.save
````
        
Setup your host name
--------------------
Confirmation emails sent from your application will refer to an EC2 instance for the host name by default, which won't work.

To fix this, enter the admin section by visiting /admin. You may need to create an account and set its admin flag to be true.

Next, click 'Site Settings', and enter `your-app-name.herokuapp.com` in the `force_hostname` field.

Setup S3 storage for uploads (optional)
---------------------------------------
This is the one non-free area. You can get S3 storage for free if you fall under the free tier for 12 months, but you may have to pay for S3 storage. This should be fairly cheap anyway, all things considered. Run the following:

`heroku config:add AWS_ACCESS_KEY_ID=<your_access_key> AWS_SECRET_ACCESS_KEY=<your_secret_key>`

navigate to `http://<your-app>.herokuapp.com/admin/site_settings`

1. Check the box for `enable_s3_uploads`
2. Paste your bucket into `s3_upload_bucket`

Keeping up to date (optional)
-----------------------------
I will try to roughly update this repo every 2 weeks, or when there's a new Discourse point release (although at this point versioning is pretty arbitrary). I'm rebasing rather than merging to maintain a clean tree, so you're going to have to force-pull and force-push to heroku.

1. `git pull --force`
1. `git push --force heroku master`
