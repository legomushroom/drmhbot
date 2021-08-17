# drmhbot [![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/heyajulia/drmhbot)

This is the source code for that powers [@DrudgeReportHeadlinesBot][bot]. It
posts the "main" [Drudge Report][drudge] headlines to the
[@DrudgeReportHeadlines][channel] Telegram channel.

The bot is currently running "serverlessly" on Heroku.
[Heroku Scheduler][scheduler] runs `hy src/main.hy` every hour on the hour.
Persistence is handled using [Heroku Redis][redis].

I hope to transition the bot to a "true" serverless environment one day.
Until then, this seems to work well enough. And it doesn't cost me anything.

[bot]: https://t.me/DrudgeReportHeadlinesBot
[drudge]: https://drudgereport.com
[channel]: https://t.me/s/DrudgeReportHeadlines
[scheduler]: https://elements.heroku.com/addons/scheduler
[redis]: https://elements.heroku.com/addons/heroku-redis
