Icebreaker
==========

Setup
-----
You'll want to set these enviornment variables up in either your `.env` file or in your [heroku enviornment variables](https://devcenter.heroku.com/articles/config-vars)

    RACK_ENV=<production/development>
    FB_APP_ID=<facebook app id>
    FB_APP_SECRET=<facebook app secret>
    DB_PATH=<database url (i.e postgres://user:password@host:port/database)

You'll also want to make sure you have all the required gems, so run `bundle install`

Running Locally
---------------
Use `foreman start` to start the web server. This will also make sure your `.env` is loaded correctly

Facebook Hackathon Pitch
------------------------
Mayank: We move fast, we break things, we hack for a day straight, and we're proud. We're engineers, and somehow we still suck at meeting people. But maybe the problem isn't with us, first impressions are hard, meeting the right people is even harder. 

Amir: This is my first Hackathon and I was hoping to meet similar minded people. I didn't have a team and I didn't know anyone here.
Wouldn't it be great if I could join a group and it could match me with people with similar interests. It'd even tell me exactly what to say to them to get a conversation going.


Valentin: *Name random person* *Say introductory sentence*
Nick: *Name random person* *use secondary information*

*Click through to facebook for one of the organizers, add as friend*
