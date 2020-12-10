# drmhbot

This is the source code for the [@DrudgeReportHeadlinesBot][bot]. It posts the
"main" headlines on the [Drudge Report][drudge] website to the
[@DrudgeReportHeadlines][channel] Telegram channel.

The bot currently runs "serverlessly" on Heroku. [Heroku Scheduler][scheduler]
runs the `main.py` file every hour on the hour. Persistence is handled using
[Heroku Redis][redis].

This codebase is by no means an example of sound engineering practices, but it
seems to work well enough in practice, and it doesn't cost me one penny to run.

[bot]: https://t.me/DrudgeReportHeadlinesBot
[drudge]: https://drudgereport.com
[channel]: https://t.me/DrudgeReportHeadlines
[scheduler]: https://elements.heroku.com/addons/scheduler
[redis]: https://elements.heroku.com/addons/heroku-redis
